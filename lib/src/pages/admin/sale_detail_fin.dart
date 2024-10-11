import 'package:kd_latin_food/src/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class SaleDetailPageFin extends StatelessWidget {
  final OrderData sale;
  final List<SalesDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SaleDetailPageFin({super.key, required this.sale, required this.saleDetails});
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Finished order Details',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Order ID: ${sale.id}',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${sale.total}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          'Total Items: ${sale.items}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Order Status: ${sale.status}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                     Text(
                      'Fecha Entrega: ${sale.fecha_firma}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Shipment Status: ${sale.statusEnvio}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      sale.createdAt != null
                          ? 'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(sale.createdAt.toString()))}'
                          : 'Date: Fecha no disponible',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 24.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Products in Order',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: saleDetails.length,
                    itemBuilder: (context, index) {
                      final detail = saleDetails[index];
                      final product = detail.product;

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: SizedBox(
                            width: 80,
                            height: 80,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://kdlatinfood.com/intranet/public/storage/products/${detail.product!.product!.image ?? ""}",
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
                          title: Text(
                            product!.product!.name!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${detail.price}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Qty: ${detail.quantity} Boxes',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                               Text(
  'SKU: ${detail.product!.barcode}\nSize: ${_getSizeText(detail.product!.sizesId)}',
  style: const TextStyle(fontSize: 16.0),
),
                              // Agrega más detalles del producto si es necesario.
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
String _getSizeText(int? sizesId) {
  switch (sizesId) {
    case 1:
      return 'GRANDE';
    case 2:
      return 'MEDIANO';
    case 3:
      return 'PEQUEÑO';
    default:
      return 'TAMAÑO DESCONOCIDO';
  }
}