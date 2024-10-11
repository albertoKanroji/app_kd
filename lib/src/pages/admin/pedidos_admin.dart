import 'package:kd_latin_food/src/models/order.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos_controller.dart';
import 'package:kd_latin_food/src/pages/admin/sale_detail_cargar.dart';
import 'package:flutter/material.dart';


class PedidosAdmin extends StatelessWidget {
  const PedidosAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Confirmation',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: FutureBuilder<List<OrderData>>(
        future: fetchSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error while load data: ${snapshot.error}'));
          } else {
            final sales = snapshot.data;
            final pendingSales =
                sales?.where((sale) => sale.status == 'PENDING').toList();

            if (pendingSales == null || pendingSales.isEmpty) {
              return const Center(
                  child: Text('Not found Pending deliveries to Load.'));
            }

            return ListView.builder(
              itemCount: pendingSales.length,
              itemBuilder: (context, index) {
                final sale = pendingSales[index];
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SaleDetailPage(
                              sale: sale,
                              saleDetails: sale.salesDetails,
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
                              'Order ID: ${sale.id}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Total: \$${sale.total}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                           
                            Text(
                              'Shipping Status: ${sale.statusEnvio}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Client: ${sale.customer!.name} ${sale.customer!.lastName}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Client Address: ${sale.customer!.address} ',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                                height: 16.0), // Espacio entre detalles y botón
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
                                  'See Details',
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
    );
  }
}
