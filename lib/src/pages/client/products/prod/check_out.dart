import 'package:kd_latin_food/src/pages/client/products/prod/carrito_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class CheckOutPage extends StatelessWidget {
  final ProductoDetailControllerCarrito cartControllerN =
      Get.put(ProductoDetailControllerCarrito());
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());
  final double shippingCost = 0.0;
  final int idCliente = 189; // ID del cliente

  CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejecutar la lógica después de que el frame ha sido renderizado
    void printUserId() {
      var user = GetStorage().read('user');

      if (user != null && user is Map) {
        var userId = user['id'];

        cartControllerN.obtenerTotalCarrito(userId);
      } else {}
    }

    printUserId();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Obx(() {
        if (cartControllerN.isLoading.value) {
          // Mostrar loader mientras calcula el total
          return const Center(
            child: CupertinoAlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(height: 8),
                  Text('Calculando total...'),
                ],
              ),
            ),
          );
        } else {
          // Si ya se calculó el total, mostrar la información
          double total = cartControllerN.totalCarrito.value;
          double subtotal = cartControllerN.totalCarrito.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.home,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Principal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ' ${con.user.phone}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ' ${con.user.address}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Billing Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shipping Cost:',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '\$${shippingCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '\$${subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '\$$total',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: Obx(() {
        return ElevatedButton(
          onPressed: () async {
            // Obtener el ID del usuario almacenado en GetStorage
            var user = GetStorage().read('user');

            if (user != null && user is Map) {
              var userId = user['id'];

              // Muestra el texto de "Realizando pago" mientras se procesa el pago
              cartControllerN.isLoading.value = true;

              // Llamada a la función para pagar el carrito usando el userId
              await cartControllerN.pagarCarrito(userId, context);

              // Después del pago, oculta el loader
              cartControllerN.isLoading.value = false;

              // Puedes imprimir el ID del usuario para verificar
            } else {
              // Si no se pudo obtener el ID del usuario, muestra un mensaje de error
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xE5FF5100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
          ),
          child: cartControllerN.isLoading.value
              ? const Text(
                  'Realizando pago...',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 253, 253),
                  ),
                )
              : const Text(
                  'Place order',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 253, 253),
                  ),
                ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
