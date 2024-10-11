// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<PresentacionKey> welcomeFromJson(String str) => List<PresentacionKey>.from(json.decode(str).map((x) => PresentacionKey.fromJson(x)));

String welcomeToJson(List<PresentacionKey> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PresentacionKey {
    int ?presentacionId;
    String? barcode;
    String ?stockBox;
    String ?stockItems;
    int ?price;
    String? size;
    Producto producto;

    PresentacionKey({
        this.presentacionId,
        this.barcode,
        this.stockBox,
        this.stockItems,
        this.price,
        this.size,
      required  this.producto,
    });

    factory PresentacionKey.fromJson(Map<String, dynamic> json) => PresentacionKey(
        presentacionId: json["presentacion_id"],
        barcode: json["barcode"],
        stockBox: json["stock_box"],
        stockItems: json["stock_items"],
        price: json["price"],
        size: json["size"],
        producto: Producto.fromJson(json["producto"]),
    );

    Map<String, dynamic> toJson() => {
        "presentacion_id": presentacionId,
        "barcode": barcode,
        "stock_box": stockBox,
        "stock_items": stockItems,
        "price": price,
        "size": size,
        "producto": producto.toJson(),
    };
}

class Producto {
    int? id;
    String? name;
    String? estaEnWoocomerce;
    String? barcode;
    String? saborId;
    double? cost;
    double? price;
    int ?stock;
    String ?image;
    int? tam;

    Producto({
        this.id,
        this.name,
        this.estaEnWoocomerce,
        this.barcode,
        this.saborId,
        this.cost,
        this.price,
        this.stock,
        this.image,
        this.tam,
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        name: json["name"],
        estaEnWoocomerce: json["EstaEnWoocomerce"],
        barcode: json["barcode"],
        saborId: json["sabor_id"],
        cost: json["cost"].toDouble(),
        price: json["price"].toDouble(),
        stock: json["stock"],
        image: json["image"],
        tam: json["tam"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "EstaEnWoocomerce": estaEnWoocomerce,
        "barcode": barcode,
        "sabor_id": saborId,
        "cost": cost,
        "price": price,
        "stock": stock,
        "image": image,
        "tam": tam,
    };
}
