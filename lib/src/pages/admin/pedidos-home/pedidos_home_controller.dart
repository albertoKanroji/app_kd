import 'dart:convert';

import 'package:kd_latin_food/src/models/order.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePedidosController extends GetxController {
  // Cambia el tipo de lista a OrderData
  RxList<OrderData> orders = <OrderData>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  Future<void> fetchSales() async {
    int maxAttempts = 3;
    int currentAttempt = 0;

    while (currentAttempt < maxAttempts) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://kdlatinfood.com/intranet/public/api/despachos-pending'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = json.decode(response.body)['data'];

          // Asigna la lista correctamente a orders en lugar de sales
          orders.assignAll(
              jsonList.map((json) => OrderData.fromJson(json)).toList());
          showSnackbar('Orders Loaded');
          return;
        } else {
          await Future.delayed(const Duration(seconds: 5));
        }
      } catch (e) {
        showSnackbar('Error to load orders $e');
        print(e);
        await Future.delayed(const Duration(seconds: 5));
      }

      currentAttempt++;
    }
    isLoading.value = false;
  }

  void showSnackbar(String s) {
    Get.snackbar(
      s,
      '',
      barBlur: 100,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
