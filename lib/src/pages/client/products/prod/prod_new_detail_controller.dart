import 'package:kd_latin_food/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductoDetailController {
  Future<Product> fetchProd(int? id) async {
     try {
      if (id == null) {
        throw ArgumentError('ID cannot be null');
      }

      final url = 'http://kdlatinfood.com/intranet/public/api/products/detail/$id';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Product.fromJson(json);
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }
   Future<List<Presentation>> fetchPresentaciones(int productId) async {
    try {
      final url = 'http://kdlatinfood.com/intranet/public/api/presentaciones/product/$productId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> presentacionesJson = json['data']['presentaciones'];
        print(presentacionesJson);
        return presentacionesJson.map((p) => Presentation.fromJson(p)).toList();
      } else {
        throw Exception('Failed to load presentations data');
      }
    } catch (e) {
      throw Exception('Failed to fetch product presentations: $e');
    }
  }
}

class Product_ {
  final int id;
  final String name;
  final String barcode;
  final double cost;
  final double price;
  final int stock;
  final String description;
  // other fields...

  Product_({
    required this.id,
    required this.name,
    required this.barcode,
    required this.cost,
    required this.price,
    required this.stock,
    required this.description,
  });

  factory Product_.fromJson(Map<String, dynamic> json) {
    return Product_(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      cost: double.parse(json['cost']),
      price: double.parse(json['price']),
      stock: json['stock'],
      description: json['descripcion'],
    );
  }
}

class Presentation {
  final int id;
  final int productId;
  final int sizeId;
  final String barcode;
  final int stockBox;
  final int stockItems;
  final String price;

  Presentation({
    required this.id,
    required this.productId,
    required this.sizeId,
    required this.barcode,
    required this.stockBox,
    required this.stockItems,
    required this.price,
  });

  factory Presentation.fromJson(Map<String, dynamic> json) {
    return Presentation(
      id: json['id'],
      productId: json['products_id'],
      sizeId: json['sizes_id'],
      barcode: json['barcode'],
      stockBox: int.parse(json['stock_box']),
      stockItems: int.parse(json['stock_items']),
      price:json['price'],

    );
  }
}