import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:kd_latin_food/src/models/new/producto_new_key.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos-home/detalle-sale/detalle_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kd_latin_food/src/models/sale_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable, camel_case_types
class Detalle_Venta extends StatelessWidget {
  final int saleId;
  final SaleController controller1 = SaleController();
  Detalle_Venta({Key? key, required this.saleId}) : super(key: key);
  Map<int, Product> selectedProducts =
      {}; // Mapa para almacenar productos seleccionados

  @override
  Widget build(BuildContext context) {
    final SaleController saleController = Get.put(SaleController());

    // Llamar a la función fetchSaleDetails con el saleId proporcionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchSaleDetails(saleId);
      saleController.fetchSaleDetails(saleId);
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
                Text('Loading Products'), // Texto personalizado
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
                    const Text(
                      'Customer Detail:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Separación entre elementos
                    Text(
                      'Name: ${saleController.data.value?.customer!.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Email: ${saleController.data.value?.customer!.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Phone: ${saleController.data.value?.customer!.phone}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20), // Separación entre elementos
                    const Text(
                      'Order Detail:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Separación entre elementos
                    Text(
                      'Order ID: ${saleController.data.value?.id}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Total: ${saleController.data.value?.total}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Boxes Qty: ${saleController.data.value?.items}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      saleController.data.value?.createdAt != null
                          ? 'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(saleController.data.value!.createdAt.toString()))}'
                          : 'Date: Fecha no disponible',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // saleController.fetchProducts();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return GetBuilder<SaleController>(
                              builder: (controller) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Seleccionar Productos:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              controller.presentaciones.length,
                                          itemBuilder: (context, index) {
                                            final PresentacionKey product =
                                                controller
                                                    .presentaciones[index];
                                            int t = product.price!;
                                            if (kDebugMode) {
                                              // print(product.tam!);
                                              print(t);
                                            }
                                            return ListTile(
                                              leading: CachedNetworkImage(
                                                imageUrl:
                                                    "https://kdlatinfood.com/intranet/public/storage/products/${product.producto.image ?? ""}",
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(),
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.contain,
                                              ),
                                              title: Text(
                                                  product.producto.name ?? ''),
                                              subtitle:
                                                  Text(product.barcode ?? ''),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return QuantityInputModal(
                                                        productName: product
                                                                .producto
                                                                .name ??
                                                            '',
                                                        productID:
                                                            product.barcode!,
                                                        saleID: saleId,
                                                        onConfirm:
                                                            (Map<int, Product>
                                                                products) {
                                                          // Agregar productos al mapa
                                                          selectedProducts
                                                              .addAll(products);
                                                        },
                                                        tam: t);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      228, 222, 21, 21),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text('Cancelar',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Cambia el color del texto a blanco
                                                  fontSize: 14.0,
                                                )),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Lógica para guardar la cantidad de productos
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xE5FF5100),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text('Confirmar',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Cambia el color del texto a blanco
                                                  fontSize: 14.0,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xE5FF5100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Add Products',
                          style: TextStyle(
                            color: Colors
                                .white, // Cambia el color del texto a blanco
                            fontSize: 14.0,
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context, saleId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xE5FF5100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Obx(() {
                        return controller1.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Load Order', // Texto del botón
                                style: TextStyle(
                                  color: Colors.white, // Color del texto
                                  fontSize: 16, // Tamaño del texto
                                ),
                              );
                      }),
                    ),
                  ],
                ),
              ),

              // Lista de detalles de la venta
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Cart Detail:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

             Expanded(
  child: Obx(() {
    // Verifica si hay datos disponibles
    if (saleController.isLoading.value) {
      // Muestra un indicador de carga mientras se obtiene la información
      return const Center(child: CircularProgressIndicator());
    }

    if (saleController.data.value == null || saleController.data.value!.salesDetails.isEmpty) {
      // Si no hay datos o la lista está vacía, muestra un mensaje
      return const Center(child: Text('No hay detalles de ventas disponibles.'));
    }

    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        // Lista desplazable de productos
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: saleController.data.value!.salesDetails.length,
          itemBuilder: (context, index) {
            final detail = saleController.data.value!.salesDetails[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: CachedNetworkImage(
                imageUrl:
                    "https://kdlatinfood.com/intranet/public/storage/products/${detail.product?.product?.image ?? ""}",
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(),
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(
                detail.product?.product?.name ?? 'Nombre no disponible',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Qty: ${detail.quantity} Boxes\nSKU: ${detail.product?.barcode ?? 'N/A'}\nSize: ${detail.product?.size?.size ?? 'N/A'}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Seguro de eliminar ${detail.product?.product?.name ?? 'este producto'}',
                        ),
                        content: const Text(
                            '¿Está seguro que desea eliminar este producto?'),
                        actions: [
                          TextButton(
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: AdaptiveTheme.of(context).mode ==
                                        AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text(
                              'Sí',
                              style: TextStyle(
                                color: AdaptiveTheme.of(context).mode ==
                                        AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();

                              // Código para eliminar
                              controller1
                                  .deleteProductFromSale(saleId: detail.id!)
                                  .then((_) {
                                // Recargar detalles
                                saleController.fetchSaleDetails(saleId);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }),
),

            ],
          );
        }
      }),
    );
  }

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
                //style: TextStyle(color: Colors.black),
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
  final int tam;
  final Function(Map<int, Product>) onConfirm;
  final SaleController saleController = Get.put(SaleController());
  QuantityInputModal({
    Key? key,
    required this.productName,
    required this.onConfirm,
    required this.productID,
    required this.saleID,
    required this.tam,
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
            decoration: InputDecoration(
              labelText: 'Cantidad',
              labelStyle: const TextStyle(
                  // color: Colors.black, // Color del texto de la etiqueta
                  ),
              hintStyle: TextStyle(
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            autofocus: true,
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
                  final String quantityText = quantityController.text.trim();
                  if (quantityText.isNotEmpty) {
                    final int? quantity = int.tryParse(quantityText);
                    if (quantity != null && quantity > 0) {
                      saleController
                          .addProductToSale(
                              saleId: saleID,
                              barcode: productID,
                              quantity: quantity)
                          .then((_) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        saleController.isLoading.value =
                            true; // Mostrar CircularProgressIndicator
                        saleController.fetchSaleDetails(saleID);
                      });
                    } else {
                      // Mostrar alerta de cantidad inválida
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Cantidad Inválida"),
                          content: const Text(
                              "Por favor ingrese una cantidad válida mayor que cero."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: AdaptiveTheme.of(context).mode ==
                                          AdaptiveThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    // Mostrar alerta de cantidad vacía
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Cantidad Vacía"),
                        content: const Text("Por favor ingrese una cantidad."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: AdaptiveTheme.of(context).mode ==
                                        AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
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
