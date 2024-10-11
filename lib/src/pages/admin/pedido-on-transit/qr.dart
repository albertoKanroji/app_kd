import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:kd_latin_food/src/pages/admin/pedido-on-transit/pedido_ontransit_controller.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos-home/detalle-sale/detalle_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kd_latin_food/src/models/sale_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable, camel_case_types
class ScanQRPage extends StatelessWidget {
  final int saleId;
  final SaleController controller1 = SaleController();
  ScanQRPage({Key? key, required this.saleId}) : super(key: key);
  Map<int, Product> selectedProducts =
      {}; // Mapa para almacenar productos seleccionados

  @override
  Widget build(BuildContext context) {
    final SaleController saleController = Get.put(SaleController());
    QRScannerController qrScannerController = Get.put(QRScannerController());
    // Llamar a la función fetchSaleDetails con el saleId proporcionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchSaleDetails(saleId);
      saleController.fetchProducts();
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
        title: Text(
          'Order Detail #$saleId', // Agrega el ID del pedido aquí
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Obx(() {
        if (saleController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(), // Estilo similar a iOS

                SizedBox(height: 10),
                Text('Loading products'), // Texto personalizado
              ],
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos del cliente
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Customer Details'),
                    _buildInfoRow(Icons.person, 'Name',
                        '${saleController.data.value?.customer!.name}'),
                    _buildInfoRow(Icons.email, 'Email',
                        '${saleController.data.value?.customer!.email}'),
                    _buildInfoRow(Icons.phone, 'Phone',
                        '${saleController.data.value?.customer!.phone}'),
                    const SizedBox(height: 20), // Separación entre secciones
                    _buildSectionTitle('Order Detail'),
                    _buildInfoRow(Icons.confirmation_number, 'Order ID',
                        '${saleController.data.value?.id}'),
                         _buildInfoRow(Icons.confirmation_number, 'Fecha Carga',
                        '${saleController.data.value?.fecha_carga}'),
                    _buildInfoRow(Icons.attach_money, 'Total',
                        '${saleController.data.value?.total}'),
                    _buildInfoRow(Icons.shopping_basket, 'Boxes Qty',
                        '${saleController.data.value?.items}'),
                    _buildInfoRow(
                      Icons.date_range,
                      'Date',
                      saleController.data.value?.createdAt != null
                          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                              DateTime.parse(saleController
                                  .data.value!.createdAt
                                  .toString()))
                          : 'Fecha no disponible',
                    ),
                  ],
                ),
              ),

              // Lista de detalles de la venta
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Order Detail:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    // Lista desplazable de productos
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:
                            saleController.data.value?.salesDetails.length ?? 0,
                        itemBuilder: (context, index) {
                          final detail =
                              saleController.data.value!.salesDetails[index];

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  // Color de fondo
                                  leading: CachedNetworkImage(
                                    imageUrl:
                                        "https://kdlatinfood.com/intranet/public/storage/products/${detail.product!.product!.image ?? ""}",
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                  ),
                                  title: Text(
                                    detail.product!.product!.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Qty: ${detail.quantity} Boxes \nSKU: ${detail.product!.barcode}\nSize: ${detail.product!.size!.size}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      qrScannerController.scanQR(
                                        context,
                                        detail.product!.keyProduct!,
                                        detail.product!.id!,
                                        detail.saleId!,
                                        detail.id,
                                        detail.scanned!,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xE5FF5100),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Usar el valor observable scanned para determinar el color del icono
                                      detail.scanned == 0
                                          ? const CircularProgressIndicator()
                                          : Icon(
                                              Icons
                                                  .check_circle_outline_outlined,
                                              size: 24.0,
                                              color: detail.scanned == 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                      Text(
                                        detail.scanned == 0
                                            ? 'No Scanned'
                                            // ignore: unrelated_type_equality_checks
                                            : detail.scanned == 1
                                                ? 'Product Scanned'
                                                : 'Product no scanned',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          //color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  // ignore: unused_element
  Future<void> _showConfirmationDialog(BuildContext context, int saleId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de cargar este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                // Cierra el diálogo sin ejecutar la acción
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Cierra el diálogo y ejecuta la acción
                Navigator.of(context).pop();
                controller1.loadOrder(saleId);
              },
              child: Text(
                'Sí',
                style: TextStyle(
                  color:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ), // Color del texto negro
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuantityInputModal extends StatelessWidget {
  final String productName;
  final String productID;
  final int saleID;
  final Function(Map<int, Product>) onConfirm;
  final SaleController saleController = Get.put(SaleController());
  QuantityInputModal({
    Key? key,
    required this.productName,
    required this.onConfirm,
    required this.productID,
    required this.saleID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agregar: $productName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 7, 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Cancelar',
                    style: TextStyle(
                      color: Colors.white, // Cambia el color del texto a blanco
                      fontSize: 14.0,
                    )),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final int quantity = int.parse(quantityController.text);
                  if (quantity > 0) {
                    // Lógica para agregar el producto al mapa
                    saleController
                        .addProductToSale(
                            saleId: saleID,
                            barcode: productID,
                            quantity: quantity)
                        .then((_) {
                      Navigator.of(context).pop();
                      saleController.isLoading.value =
                          true; // Mostrar CircularProgressIndicator
                      saleController.fetchSaleDetails(saleID);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xE5FF5100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Agregar',
                    style: TextStyle(
                      color: Colors.white, // Cambia el color del texto a blanco
                      fontSize: 14.0,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildInfoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 18),
      const SizedBox(width: 10),
      Text(
        '$label:',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(width: 5),
      Flexible(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
