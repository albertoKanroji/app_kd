import 'package:kd_latin_food/src/models/order.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos-home/detalle-sale/detalle_page.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos-home/pedidos_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePedidosView extends StatelessWidget {
  final HomePedidosController controller = Get.put(HomePedidosController());
  final RxBool isRefreshing = false.obs;

  HomePedidosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending orders to confirm',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.5,
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
      body: Obx(
        () {
          if (controller.orders.isEmpty && !controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.orders.isEmpty && controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                OrderData order = controller.orders[index];

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      onTap: () {
                        // Navega a la página de detalles cuando se hace clic.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detalle_Venta(
                              saleId: order.id!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: #${order.id}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Total: \$${order.total}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Shipping Status: ${order.statusEnvio}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Client: ${order.customer!.name} ${order.customer!.lastName}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Address Client: ${order.customer!.address}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16.0), // Espacio entre detalles y botón
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 24.0,
                                ),
                                child: Text(
                                  'See details',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (!isRefreshing.value) {
              isRefreshing.value = true;
              try {
                await controller.fetchSales();
              } finally {
                isRefreshing.value = false;
              }
            }
          },
          backgroundColor: const Color(0xE5FF5100),
          child: isRefreshing.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white, // Establece el color del icono en blanco
                ),
        ),
      ),
    );
  }
}
