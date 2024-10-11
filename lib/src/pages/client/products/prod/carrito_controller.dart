import 'package:kd_latin_food/src/models/carrito.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/pedido_realizado.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

class ProductoDetailControllerCarrito extends GetxController {
  var isLoading = false.obs; // Observable para el loader
  var cartItems = [].obs;
  var totalCarrito = 0.0.obs;
  Future<void> agregarAlCarrito({
    required int presentacionesId,
    required int idCliente,
    required int items,
  }) async {
    isLoading.value = true; // Mostrar el loader

    final url = 'http://kdlatinfood.com/intranet/public/api/carrito/agregar';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'presentaciones_id': presentacionesId,
          'id_cliente': idCliente,
          'items': items,
        }),
      );

      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        final responseData = jsonDecode(response.body);
        print("Producto agregado al carrito: $responseData");
        Get.snackbar('Éxito', 'Producto agregado al carrito correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        // La solicitud falló
        print("Error al agregar el producto al carrito: ${response.body}");
        Get.snackbar('Error', 'Error al agregar el producto al carrito',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Error en la conexión',
          snackPosition: SnackPosition.TOP, colorText: Colors.red);
    } finally {
      isLoading.value = false; // Ocultar el loader
    }
  }

  // Función para obtener los productos del carrito de un cliente
// Lista observable de productos en el carrito

  // Función para obtener los productos del carrito de un cliente
  Future<void> obtenerCarritoCliente(int idCliente) async {
   // isLoading.value = true; // Mostrar el loader
    final url = 'http://kdlatinfood.com/intranet/public/api/carrito/$idCliente';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Si la respuesta indica que el carrito está vacío
        if (responseData['success'] == false &&
            responseData['message'] == "El carrito está vacío") {
          cartItems.clear(); // Limpiar el carrito
          // Get.snackbar('Carrito vacío', 'No tienes productos en el carrito',
          //     snackPosition: SnackPosition.TOP);
        } else if (responseData['success'] == true) {
          // Convertir la lista de productos del carrito a instancias de CarritoItem
          List<CarritoItem> items = (responseData['data'] as List)
              .map((item) => CarritoItem.fromJson(item))
              .toList();
          cartItems.value = items;
         
        } else {
          // Get.snackbar('Error', 'No se pudo obtener el carrito del cliente',
          //     snackPosition: SnackPosition.TOP, colorText: Colors.red);
        }
      } else {
        // print("Error al obtener el carrito: ${response.body}");
        // Get.snackbar('Error', 'Error al obtener el carrito del cliente',
        //     snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    } catch (e) {
      // print("Error: $e");
      // Get.snackbar('Error', 'Error en la conexión',
      //     snackPosition: SnackPosition.TOP, colorText: Colors.red);
    } finally {
      isLoading.value = false; // Ocultar el loader
    }
  }

  // Función para decrementar la cantidad de un producto en el carrito
  Future<void> decrementQuantity({
    required int idCliente,
    required int presentacionesId,
  }) async {
    isLoading.value = true; // Mostrar el loader

    final url = 'http://kdlatinfood.com/intranet/public/api/carrito/decrement';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_cliente': idCliente, // Enviamos el ID del cliente
          'presentaciones_id':
              presentacionesId, // Enviamos el ID de la presentación
        }),
      );

      if (response.statusCode == 200) {
        // Actualizar el carrito después de la eliminación
        obtenerCarritoCliente(idCliente);
        Get.snackbar('Éxito', 'Producto actualizado correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        print("Error al eliminar el producto del carrito: ${response.body}");
        Get.snackbar('Error', 'Error al eliminar el producto del carrito',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Error en la conexión',
          snackPosition: SnackPosition.TOP, colorText: Colors.red);
    } finally {
      isLoading.value = false; // Ocultar el loader
    }
  }

  // Función para incrementar la cantidad de un producto en el carrito
  Future<void> incrementQuantity({
    required int presentacionesId,
    required int idCliente,
    required int items,
  }) async {
    isLoading.value = true; // Mostrar el loader

    final url = 'http://kdlatinfood.com/intranet/public/api/carrito/agregar';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'presentaciones_id': presentacionesId,
          'id_cliente': idCliente,
          'items': items,
        }),
      );

      if (response.statusCode == 200) {
        // Actualizar el carrito después de agregar
        obtenerCarritoCliente(idCliente);
        Get.snackbar('Éxito', 'Producto actualizado correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        print("Error al agregar el producto al carrito: ${response.body}");
        Get.snackbar('Error', 'Error al agregar el producto al carrito',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Error en la conexión',
          snackPosition: SnackPosition.TOP, colorText: Colors.red);
    } finally {
      isLoading.value = false; // Ocultar el loader
    }
  }

  // Función para obtener el total del carrito de un cliente
 Future<void> obtenerTotalCarrito(int idCliente) async {
   //isLoading.value = true; // Mostrar el loader

  final url = 'http://kdlatinfood.com/intranet/public/api/carrito/total/$idCliente';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Response data: $responseData");

      if (responseData['success'] == true) {
        // Asegúrate de que el total sea numérico y conviértelo a double
        double total = double.tryParse(responseData['total'].toString()) ?? 0.0;

        totalCarrito.value = total; // Asigna el total
        //print("Total del carrito del cliente $idCliente: ${totalCarrito.value}");

        // Get.snackbar(
        //   'Total Carrito',
        //   'El total es \$${totalCarrito.value.toStringAsFixed(2)}',
        //   snackPosition: SnackPosition.TOP,
        // );
      } else {
        // Get.snackbar(
        //   'Error',
        //   'No se pudo obtener el total del carrito',
        //   snackPosition: SnackPosition.TOP,
        //   colorText: Colors.red,
        // );
      }
    } else {
      print("Error al obtener el total del carrito: ${response.body}");
      // Get.snackbar(
      //   'Error',
      //   'Error al obtener el total del carrito: ${response.body}',
      //   snackPosition: SnackPosition.TOP,
      //   colorText: Colors.red,
      // );
    }
  } catch (e) {
    print("Error: $e");
    Get.snackbar(
      'Error',
      'Error en la conexión: $e',
      snackPosition: SnackPosition.TOP,
      colorText: Colors.red,
    );
  } finally {
    isLoading.value = false; // Ocultar el loader
  }
}
Future<void> pagarCarrito(int idCliente, BuildContext context) async {
  final url = 'http://kdlatinfood.com/intranet/public/api/carrito/pagar';

  try {
    // Enviar la solicitud POST con el cliente_id en el cuerpo
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'cliente_id': idCliente,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        // Navegar a la página de pedido realizado si el pago fue exitoso
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: PedidoRealizadoPage(),
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo realizar el pago.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
        );
      }
    } else {
      print("Error en la respuesta del servidor: ${response.body}");
      Get.snackbar(
        'Error',
        'Error en la respuesta del servidor.',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  } catch (e) {
    print("Error: $e");
    Get.snackbar(
      'Error',
      'Error en la conexión: $e',
      snackPosition: SnackPosition.TOP,
      colorText: Colors.red,
    );
  }
}


  // Cantidad total de items en el carrito
  int get cartItemCount => cartItems.length;
}
