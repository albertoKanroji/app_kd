// ignore_for_file: prefer_const_constructors

import 'package:kd_latin_food/src/models/new/cliente_sale_new.dart';
import 'package:kd_latin_food/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:kd_latin_food/src/pages/envios/envio_detalle.dart';
import 'package:kd_latin_food/src/pages/envios/envios_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClientOrdersPage extends StatelessWidget {
  final ClientOrdersController con = Get.put(ClientOrdersController());
  final int customerId;
  final ClientProfileInfoController con1 = Get.put(ClientProfileInfoController());
  final ClientProductsListController con5 = Get.put(ClientProductsListController());

  ClientOrdersPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        elevation: 0.5,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: const [
              // Coloca aquí la imagen o cualquier otro contenido que desees tener detrás del AppBar
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                con5.changeTab(0);
              },
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: RefreshIndicator(
        onRefresh: () async {
          // Llama a fetchClientOrders cuando el usuario deslice hacia abajo
          await con.fetchClientOrders(customerId);
        },
        
        child: FutureBuilder<List<Sale>>(
          future: con.fetchClientOrders(customerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoAlertDialog(
                content: Column(
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(height: 8),
                    Text('Loading Data...'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.wifi_tethering_off_sharp,
                        size: 100,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        'No tienes conexion a internet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xE5FF5100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.card_travel,
                        size: 100,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        'No hay pedidos disponibles',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xE5FF5100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order # ${order.id}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${con1.user.address}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => EnvioDetallePage(order: order));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Status: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        (() {
                                          if (order.statusEnvio == "FIN") {
                                            return "Complete";
                                          } else if (order.statusEnvio == "PENDIENTE" &&
                                              order.status == "PENDING") {
                                            return "Ordered";
                                          } else if (order.statusEnvio == "PENDIENTE" &&
                                              order.status == "PAID") {
                                            return "Confirmed";
                                          } else if (order.status == "PAID" &&
                                              order.statusEnvio == "ACTUAL") {
                                            return "On Transit";
                                          } else {
                                            return ""; // Manejo de caso por defecto
                                          }
                                        })(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xE5FF5100),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Color(0xE5FF5100),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}