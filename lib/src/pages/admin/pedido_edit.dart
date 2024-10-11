import 'dart:convert';

import 'package:kd_latin_food/src/models/order.dart';
import 'package:kd_latin_food/src/pages/admin/botonbar.dart';
import 'package:kd_latin_food/src/pages/admin/sale_detail_cargar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/sale_model.dart';

class SaleEdit extends StatefulWidget {
  final OrderData sale;

  final List<SaleDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  SaleEdit({super.key, required this.sale, required this.saleDetails});

  @override
  // ignore: library_private_types_in_public_api
  _SaleEditState createState() => _SaleEditState();
}

class _SaleEditState extends State<SaleEdit> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String selectedBarcode ='';
  List<Product> products = [];
  bool isEditing = false;
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  void refreshPage() {
    Navigator.of(context).pop();
    goToAdminPedidos();
    Get.toNamed('/homeadmin');
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SaleEdit(
        sale: widget.sale,
        saleDetails: widget.saleDetails,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    getProductsEDIT();
  }

  Future<void> getProductsEDIT() async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
        });

        if (products.isNotEmpty) {
          selectedBarcode = products[0].barcode!;
        }
      } else {
        // Manejo de errores
      }
    } catch (e) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey1,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Order',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID: ${widget.sale.id}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.receipt,
                      size: 32.0,
                      color: Color(0xE5FF5100),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.saleDetails.length,
                  itemBuilder: (context, index) {
                    final detail = widget.saleDetails[index];
                    final product = detail.product;

                    return GestureDetector(
                      onTap: () {
                        // Mostrar un SimpleDialog para editar la cantidad
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Qty'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Qty'),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    String newQuantity = quantityController
                                        .text; // Obtener la nueva cantidad del TextField
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo

                                    // Realizar la solicitud HTTP POST para enviar los datos al servidor Laravel
                                    final response = await http.post(
                                      Uri.parse(
                                          'https://kdlatinfood.com/intranet/public/api/update-sale'), // Reemplaza con la URL de tu API
                                      body: {
                                        'sale_id': widget.sale.id
                                            .toString(), // Reemplaza con el ID de la venta
                                        'product_id': product.id
                                            .toString(), // Reemplaza con el ID del producto que estás editando
                                        'quantity': newQuantity,
                                      },
                                    );

                                    if (response.statusCode == 200) {
                                      // Si la solicitud fue exitosa, puedes mostrar un mensaje de éxito
                                      showDialog(
                                        context: widget
                                            ._scaffoldKey1.currentContext!,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Éxito'),
                                            content: const Text(
                                                'Qty Changed.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Get.snackbar(
                                                    'Qty Change',
                                                    'Order ID: ${widget.sale.id}',
                                                    barBlur: 100,
                                                    animationDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                  );
                                                  Get.offAll(
                                                      ClientProductsListPageAdmin(),
                                                      transition:
                                                          Transition.fade);

                                                  Get.to(SaleDetailPage(
                                                    sale: widget.sale,
                                                    saleDetails: widget
                                                        .sale.salesDetails,
                                                  ));
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // Actualizar la cantidad en el modelo de datos local si es necesario
                                      // ...
                                    } else {
                                      // Si la solicitud no fue exitosa, muestra un mensaje de error
                                      showDialog(
                                        context: widget
                                            ._scaffoldKey1.currentContext!,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'Error al actualizar la cantidad.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Cerrar el diálogo sin guardar cambios
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(
                            product.name!,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${detail.price}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Quantity of Items: ${detail.quantity}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                                Icons.delete), // Icono de bote de basura
                            onPressed: () {
                              // Muestra un cuadro de diálogo de confirmación
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Are you sure delete this product?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Cierra el cuadro de diálogo sin hacer nada si se presiona "No"
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final saleDetailId = detail.id
                                              .toString(); // Convierte el id en una cadena

                                          final response = await http.delete(
                                            Uri.parse(
                                              'https://kdlatinfood.com/intranet/public/api/sales/borrar/$saleDetailId',
                                            ),
                                          );

                                          if (response.statusCode == 200) {
                                            // Si la solicitud fue exitosa, muestra un cuadro de diálogo de éxito
                                            // print(response.statusCode);
                                            showDialog(
                                              context: widget._scaffoldKey1
                                                  .currentContext!,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Éxito'),
                                                  content: const Text(
                                                      'Producto eliminado con éxito.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          widget.saleDetails
                                                              .removeAt(index);
                                                        });
                                                        Get.snackbar(
                                                          'Product Deleted',
                                                          'Order ID: ${widget.sale.id}',
                                                          barBlur: 100,
                                                          animationDuration:
                                                              const Duration(
                                                                  seconds: 2),
                                                        );
                                                        Get.offAll(
                                                            ClientProductsListPageAdmin(),
                                                            transition:
                                                                Transition
                                                                    .fade);

                                                        Get.to(SaleDetailPage(
                                                          sale: widget.sale,
                                                          saleDetails: widget
                                                              .sale
                                                              .salesDetails,
                                                        ));
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            // Si la solicitud no fue exitosa, muestra un cuadro de diálogo de error
                                            showDialog(
                                              context: widget._scaffoldKey1
                                                  .currentContext!,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'Error al eliminar el producto.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Cierra el cuadro de diálogo de error
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text('Sí'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Spacer(),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Añadir Producto"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DropdownButton<String>(
                          value: selectedBarcode, // Valor seleccionado
                          onChanged: (String? newValue) {
                             
                            setState(() {
                              selectedBarcode = newValue!;
                              if (kDebugMode) {
                                print(selectedBarcode);
                              }
                            });
                             setState(() {});
                          },
                          items: products
                              .map<DropdownMenuItem<String>>((Product product) {
                            return DropdownMenuItem<String>(
                              value: product.barcode,
                              child:Text('${product.barcode} - ${product.name}'),
                            );
                          }).toList(),
                        ),
                        TextField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                              labelText: 'Cantidad de Artículos'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          //String barcode = barcodeController.text;
                          int quantity =
                              int.tryParse(quantityController.text) ?? 0;

                          final response = await http.post(
                            Uri.parse(
                                'https://kdlatinfood.com/intranet/public/api/add-product-to-sale'), // Reemplaza con la URL de tu API
                            body: {
                              'sale_id': '${widget.sale.id}',
                              'barcode': selectedBarcode,
                              'quantity': quantity.toString(),
                            },
                          );
                          if (response.statusCode == 200) {
                            showDialog(
                              context: widget._scaffoldKey1.currentContext!,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Éxito'),
                                  content: const Text(
                                      'Producto guardado con éxito.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Get.snackbar(
                                          'Producto guardado con éxito',
                                          'De la venta: ${widget.sale.id}',
                                          barBlur: 100,
                                          animationDuration:
                                              const Duration(seconds: 2),
                                        );
                                        Get.offAll(
                                            ClientProductsListPageAdmin(),
                                            transition: Transition.fade);

                                        Get.to(SaleDetailPage(
                                          sale: widget.sale,
                                          saleDetails: widget.sale.salesDetails,
                                        ));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            Get.offAll(ClientProductsListPageAdmin(),
                                transition: Transition.fade);

                            Get.to(SaleDetailPage(
                              sale: widget.sale,
                              saleDetails: widget.sale.salesDetails,
                            ));
                            barcodeController.clear();
                            quantityController.clear();
                          } else {
                            showDialog(
                              context: widget._scaffoldKey1.currentContext!,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Error al guardar el producto.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Guardar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancelar"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Añadir Producto"),
          ),
        ],
      ),
    );
  }
}
