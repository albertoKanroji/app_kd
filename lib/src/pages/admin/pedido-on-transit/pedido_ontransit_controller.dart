import 'dart:convert';

import 'package:kd_latin_food/src/models/admin/sales/sale_detalle.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos-home/detalle-sale/detalle_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class QRScannerController extends GetxController {
  var getResult = 'QR Code Result';
  RxInt scanned = 0.obs;
  Rx<Sale?> sale = Rx<Sale?>(null);
  final SaleController saleController = Get.put(SaleController());
  final RxBool isLoading = false.obs;
  void _updateScreen() {
    update();
  }

  void fetchSaleDetails(int id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/sales/$id'));
      if (response.statusCode == 200) {
        sale.value = Sale.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to load sale details');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendQRCodeToAPI(BuildContext context, String qrCode,
      String keyProduct, int productID, int saleID, int? id) async {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Loading...'),
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text(
                'Please Wait...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final apiUrl =
        Uri.parse('https://kdlatinfood.com/intranet/public/api/verify-qrcode');

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'ventaId': saleID.toString(),
          'qrCode': qrCode,
          'product_id': productID.toString(),
          'venta_detalle': id.toString(),
          'key_prod': keyProduct,
        },
      );

      Get.back(); // Cerrar el diálogo de carga

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('message')) {
          final message = jsonResponse['message'];

          if (message == 'Go to the next product.') {
            _updateSale();
            _updateScreen();
            _showAlertDialog(message);
          } else if (message == 'All QR are Scanned.') {
            // ignore: use_build_context_synchronously
            _showAllScannedDialog(context, message);
            _updateSale();
          } else {
            _showSnackbar(message);
          }
        }

        if (kDebugMode) {
          print('API Respond: ${response.body}');
        }
      } else {
        _showErrorDialog(
            'Error en la solicitud a la API: ${response.statusCode}');
      }
    } catch (e) {
      Get.back(); // Cerrar el diálogo de carga
      _showErrorDialog('Error de conexión: $e');
      if (kDebugMode) {
        print('$e');
      }
      if (kDebugMode) {
        print('Error de conexión: $e');
      }
    }
  }

  void _updateSale() async {
    final secondResponse = await http.post(
      Uri.parse(
          'https://kdlatinfood.com/intranet/public/api/updateActualSales'),
    );

   
    if (kDebugMode) {
      print('Respuesta del segundo POST: ${secondResponse.body}');
    }
  }

  void _showSnackbar(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('API Respond'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('QR Succesfull'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  void _showAllScannedDialog(BuildContext context, String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Successfully'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void scanQR(
    BuildContext context,
     String keyProduct,
      int productID,
      int saleID, 
      int? id, 
      int scannedValue) async {
    if (kDebugMode) {
      print('Valor de keyProduct: $keyProduct');
      print('Valor de productID: $productID');
      print('Valor de saleID: $saleID');
      print('Valor de Saleid_detalle: $id');
      print('Valor del código QR: $getResult');
      print('Scan: $scannedValue');
    }

    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color de fondo del cabezal del escáner
        'Cancel', // Texto del botón de cancelar
        true, // Muestra la luz del flash
        ScanMode.QR, // Modo QR
      );

      if (result != '-1') {
        getResult = result;

        // Imprimir por consola los valores que llegan a la función
        if (kDebugMode) {
          print('Valor de keyProduct: $keyProduct');
          print('Valor de productID: $productID');
          print('Valor de saleID: $saleID');
          print('Valor de Saleid_detalle: $id');
          print('Valor del código QR: $getResult');
        }

        // Llamar a la función sendQRCodeToAPI con los valores recibidos
        // ignore: use_build_context_synchronously
        sendQRCodeToAPI(context, getResult, keyProduct, productID, saleID, id)
            .then((_) {
          saleController.fetchSaleDetails(saleID);
        });
        if (kDebugMode) {
          print(scannedValue);
        }
      }
    } catch (e) {
      _showErrorDialog('Error al escanear el código QR: $e');
      if (kDebugMode) {
        print('Error al escanear el código QR: $e');
      }
    }
  }

  void _showErrorDialog(String error) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
