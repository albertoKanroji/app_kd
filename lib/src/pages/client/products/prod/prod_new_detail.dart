// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:kd_latin_food/src/models/product.dart';
import 'package:kd_latin_food/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/carrito_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/client_products_list_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/prod_new_detail_controller.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


// ignore: must_be_immutable
class ProductoDetalleNPage extends StatelessWidget {
  final ProductoDetailController con = Get.put(ProductoDetailController());
  final ProductsListController con2 = Get.put(ProductsListController());
  final Product product;
  final int? customerId;
 var user = GetStorage().read('user');
 
  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  final ClientProductsListController con5 =
      Get.put(ClientProductsListController());
  final ProductoDetailControllerCarrito controller =
      Get.put(ProductoDetailControllerCarrito());

  ProductoDetalleNPage({super.key, required this.product, this.customerId});
  int quantity = 1;
  String selectedSize = ""; // Variable para rastrear el tamaño seleccionado
  RxBool isAddToCartEnabled =
      false.obs; // Variable para habilitar/deshabilitar el botón "Add to Cart"
  int selectedSizeMultiplier = 1; // Multiplicador del precio inicial
  final cartController = Get.find<CartController>();
  int counter = 0;
  final Map<int, int> selectedSizeMultipliers = {};

  CartItem? findCartItemByProduct(Product product) {
    try {
      return cartController.cartItems
          .firstWhere((cartItem) => cartItem.product.id == product.id);
    } catch (_) {
      return null; // Retorna null si no se encuentra ningún CartItem
    }
  }

  RxInt selectedQuantity = 1.obs;
  RxString selectedPrice = '0.00'.obs;
  RxInt selectedSizeId = 0.obs;
  Future<void> _refreshProductDetails() async {
    try {
      await con.fetchPresentaciones(product.id);
      print('Datos recargados.');
    } catch (e) {
      print('Error al recargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variable observable para controlar el estado de carga
    RxBool isLoading = true.obs;
    RxList<Presentation> presentaciones = <Presentation>[].obs;

    // Llamada a la función fetchPresentaciones al cargar la página
    con.fetchPresentaciones(product.id).then((data) {
      presentaciones.value = data; // Guardamos las presentaciones en la lista
      isLoading.value = false; // Cambiamos el estado a cargado
    }).catchError((error) {
      print("Error al cargar las presentaciones: $error");
      isLoading.value = false; // Si falla, también detenemos el loader
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detail Item'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Obx(
        () => isLoading.value
            ? const CupertinoAlertDialog(
                content: Column(
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(height: 8),
                    Text('Loading data...'),
                  ],
                ),
              ) // Loader
            : RefreshIndicator(
                // Envolver con RefreshIndicator
                onRefresh: _refreshProductDetails, // Función de recarga
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 300,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.image ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Producto, descripción y otros widgets...
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          height: 1.5,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        Text(
                                          '5',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.descripcion!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Presentaciones:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Crear botones por cada presentación
                                Obx(() => presentaciones.isEmpty
                                    ? const Text(
                                        'No hay presentaciones disponibles.')
                                    : Center(
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: presentaciones.map((p) {
                                            bool isSelected =
                                                selectedSizeId.value ==
                                                    p.id;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isSelected
                                                      ? Colors
                                                          .green // Si está seleccionado, verde
                                                      : const Color(
                                                          0xE5FF5100), // Si no, color por defecto
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                ),
                                                onPressed: () {
                                                 // print(p.id);
                                                  // Actualizamos el tamaño y el precio seleccionados
                                                  selectedSizeId.value =
                                                      p.id;
                                                  selectedPrice.value = p.price;
                                                  selectedQuantity.value = 1;
                                                },
                                                child: Text(
                                                  "${_getSizeText(p.sizeId)} X ${p.stockBox}", 
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                      ),
                                const SizedBox(height: 20),

                                // Sección para seleccionar cantidad
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (selectedQuantity.value > 1) {
                                          selectedQuantity.value--;
                                        }
                                      },
                                      shape: const CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.grey,
                                      padding: const EdgeInsets.all(15.0),
                                      child: const Icon(Icons.remove,
                                          color: Colors.white),
                                    ),
                                    Obx(() => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(
                                            '${selectedQuantity.value}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              //color: Colors.black87,
                                            ),
                                          ),
                                        )),
                                    RawMaterialButton(
                                      onPressed: () {
                                        selectedQuantity.value++;
                                      },
                                      shape: const CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.grey,
                                      padding: const EdgeInsets.all(15.0),
                                      child: const Icon(Icons.add,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Mostrar el precio seleccionado
                                Obx(() => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Precio:',
                                          style: TextStyle(
                                            fontSize:
                                                14, // Tamaño de fuente en sp
                                            height:
                                                1.5, // Altura de línea en sp
                                            fontFamily:
                                                'Inter', // Nombre de la fuente (si se ha agregado a los recursos)
                                            fontWeight: FontWeight
                                                .w400, // Peso de la fuente (400 es igual a FontWeight.normal)
                                            color: Color(
                                                0xFF999999), // Color del texto en formato ARGB (8 dígitos hexadecimales)
                                          ),
                                        ),
                                        Text(
                                          '\$${selectedPrice.value}',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    )),

                                const SizedBox(height: 20),

                                // Mostrar el total multiplicado por la cantidad
                                Obx(() {
                                  double totalPrice =
                                      double.tryParse(selectedPrice.value) ?? 0;
                                  int quantity = selectedQuantity.value;
                                  double total = totalPrice * quantity;

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total: \$${total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),

                                      // Botón "Add to Cart"
                                      if (selectedPrice.value != '0.00' &&
                                          selectedQuantity.value > 0)
                                        Obx(() => ElevatedButton.icon(
                                              onPressed: () {
                               var user = GetStorage().read('user');
                                var userId = user['id'];
                                                if (!controller
                                                    .isLoading.value) {
                                                  // Llamada a la función para agregar al carrito
                                                  controller.agregarAlCarrito(
                                                    presentacionesId: selectedSizeId.value, // ID de la presentación seleccionada
                                                    idCliente:userId, // Aquí debes pasar el ID del cliente real
                                                    items: selectedQuantity.value, // Cantidad seleccionada
                                                  );
                                                }
                                              },
                                              icon: controller.isLoading.value
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white),
                                                        strokeWidth: 2.0,
                                                      ),
                                                    )
                                                  : const Icon(Icons
                                                      .shopping_bag_outlined),
                                              label: controller.isLoading.value
                                                  ? const Text("Agregando...")
                                                  : const Text("Add to Cart"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                    ],
                                  );
                                }),
                                const SizedBox(height: 20),
                                // Otros elementos de la UI...
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
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
