import 'package:kd_latin_food/src/models/carrito.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/carrito_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/check_out.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class CartPage extends StatelessWidget {
  final ProductoDetailControllerCarrito cartControllerN =
      Get.put(ProductoDetailControllerCarrito());

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el carrito del cliente (ID 189 como ejemplo)
   
    void printUserId() {
  var user = GetStorage().read('user');
  
  if (user != null && user is Map) {
    var userId = user['id'];
  
    cartControllerN.obtenerCarritoCliente(userId);
  } else {
   
  }
}
    printUserId();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Obx(() {
        if (cartControllerN.isLoading.value) {
          // Mostrar loader mientras carga
          return const CupertinoAlertDialog(
            content: Column(
              children: [
                CupertinoActivityIndicator(),
                SizedBox(height: 8),
                Text('Loading data...'),
              ],
            ),
          );
        } else if (cartControllerN.cartItems.isEmpty) {
          // Si el carrito está vacío
          return const Center(
            child: Text('No hay productos en el carrito'),
          );
        } else {
          // Mostrar productos en el carrito
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7B33).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'You have ${cartControllerN.cartItems.length} items in your shopping cart',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF7B33),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartControllerN.cartItems.length,
                    itemBuilder: (context, index) {
                      final CarritoItem cartItem =
                          cartControllerN.cartItems[index];
                      final Producto producto = cartItem
                          .producto; // Obtenemos el producto desde cartItem
                      // Usamos el modelo correctamente

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          // Lógica para eliminar el producto del carrito
                          // cartControllerN.removeFromCart(cartItem); // Implementar eliminación
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://kdlatinfood.com/intranet/public/storage/products/${producto.product.image}', // Concatenamos la URL base con la imagen
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.product
                                      .name, // Acceso correcto al campo "name"
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height:
                                        4), // Espacio entre el nombre y el tamaño
                                Text(
                                  _getSizeText(producto
                                      .sizesId), // Muestra el tamaño según el sizesId
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${(double.parse(producto.price) * cartItem.items).toStringAsFixed(2)}', // Usamos "items" y "price" del modelo
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline_outlined),
                                      onPressed: () {
                                        // Decrementar cantidad

                                        cartControllerN.decrementQuantity(
                                          idCliente:
                                              189, // Asegúrate de tener este campo en el modelo
                                          presentacionesId: cartItem
                                              .presentacionesId, // Campo de presentación del producto
                                        );
                                      },
                                    ),
                                    Text(
                                      cartItem.items
                                          .toString(), // Mostramos la cantidad de items
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        // Incrementar cantidad
                                        cartControllerN.incrementQuantity(
                                          presentacionesId: cartItem
                                              .presentacionesId, // Campo de presentación del producto
                                          idCliente: cartItem
                                              .idCliente, // Cliente asociado
                                          items:
                                              1, // Solo añadimos una unidad extra
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: Obx(() {
        return ElevatedButton(
          onPressed: cartControllerN.cartItems.isNotEmpty
              ? () {
                  // Acción de realizar pedido
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: CheckOutPage(),
                    ),
                  );
                }
              : null, // Deshabilita el botón si no hay productos en el carrito
          style: ElevatedButton.styleFrom(
            backgroundColor: cartControllerN.cartItems.isNotEmpty
                ? const Color(0xE5FF5100)
                : Colors
                    .grey, // Cambia el color del botón si está deshabilitado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

String _getSizeText(int sizesId) {
  switch (sizesId) {
    case 1:
      return 'Grande';
    case 2:
      return 'Mediano';
    case 3:
      return 'Pequeño';
    default:
      return 'Tamaño desconocido'; // En caso de que sizesId no esté dentro de los valores esperados
  }
}
