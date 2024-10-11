import 'package:kd_latin_food/src/models/new/cliente_sale_new.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientOrdersController {
Future<List<Sale>> fetchClientOrders(int customerId) async {
  const maxAttempts = 3;
  var attempts = 0;

  while (attempts < maxAttempts) {
    try {
      final url = 'https://kdlatinfood.com/intranet/public/api/clientes/find/$customerId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('JSON Data: $jsonData');
        final cus = CustomerNew.fromJson(jsonData);

        if (cus.sale != null) {
          return cus.sale!;
        } else {
          throw Exception('No sales found for customer.');
        }
      } else {
        print('Error: Server returned status code ${response.statusCode}');
        throw Exception('Failed to fetch client orders');
      }
    } catch (e) {
      print('Attempt $attempts failed with error: $e');
      attempts++;
      await Future.delayed(const Duration(seconds: 2)); // Retraso antes del próximo intento
    }
  }

  throw Exception('Failed after $maxAttempts attempts');
}

}
