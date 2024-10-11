// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    bool? success;
    List<OrderData> data;

    Welcome({
        this.success,
      required   this.data,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        data: List<OrderData>.from(json["data"].map((x) => OrderData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class OrderData {
    int? id;
    String? total;
    int? items;
    String? cash;
    String? change;
    String ?status;
    int? userId;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? fecha_carga;
    String? fecha_escaneo;
    String? fecha_firma;
    dynamic clienteId;
    String ?statusEnvio;
    int ?customerId;
    dynamic woocommerceOrderId;
    String ?editado;
    String ?scaneoCompleto;
    dynamic totalCajas;
    dynamic longitude;
    dynamic latitude;
    dynamic qbId;
    List<SalesDetail> salesDetails;
    Customer ?customer;
    

    OrderData({
        this.id,
        this.total,
        this.items,
        this.cash,
        this.change,
        this.status,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.clienteId,
        this.statusEnvio,
        this.customerId,
        this.woocommerceOrderId,
        this.editado,
        this.scaneoCompleto,
        this.totalCajas,
        this.longitude,
        this.latitude,
        this.qbId,
       required  this.salesDetails,
        this.customer,
        this.fecha_carga,
        this.fecha_escaneo,
        this.fecha_firma
        
    });

    factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"],
        total: json["total"],
        items: json["items"],
        cash: json["cash"],
        change: json["change"],
        status: json["status"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        clienteId: json["cliente_id"],
        statusEnvio: json["status_envio"],
        customerId: json["CustomerID"],
        woocommerceOrderId: json["woocommerce_order_id"],
        editado: json["editado"],
        scaneoCompleto: json["scaneo_completo"],
        totalCajas: json["total_cajas"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        qbId: json["QB_id"],
        salesDetails: List<SalesDetail>.from(json["sales_details"].map((x) => SalesDetail.fromJson(x))),
        customer: Customer.fromJson(json["customer"]),
        fecha_carga: json["fecha_carga"],
        fecha_escaneo: json["fecha_escaneo"],
        fecha_firma: json["fecha_firma"]

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "items": items,
        "cash": cash,
        "change": change,
        "status": status,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "cliente_id": clienteId,
        "status_envio": statusEnvio,
        "CustomerID": customerId,
        "woocommerce_order_id": woocommerceOrderId,
        "editado": editado,
        "scaneo_completo": scaneoCompleto,
        "total_cajas": totalCajas,
        "longitude": longitude,
        "latitude": latitude,
        "QB_id": qbId,
        "sales_details": List<dynamic>.from(salesDetails.map((x) => x.toJson())),
        "customer": customer,
        "fecha_carga": fecha_carga,
        "fecha_escaneo": fecha_escaneo,
        "fecha_firma": fecha_firma
    };
}

class Customer {
    int? id;
    String? name;
    String? lastName;
    dynamic lastName2;
    String?email;
    String? password;
    String? address;
    String? phone;
    int? saldo;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? image;
    dynamic woocommerceClienteId;
    String? notificationToken;
    String? firebase;
    String? urlFirebase;
    int? qbId;

    Customer({
        this.id,
        this.name,
        this.lastName,
        this.lastName2,
        this.email,
        this.password,
        this.address,
        this.phone,
        this.saldo,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.woocommerceClienteId,
        this.notificationToken,
        this.firebase,
        this.urlFirebase,
        this.qbId,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        lastName2: json["last_name2"],
        email: json["email"],
        password: json["password"],
        address: json["address"],
        phone: json["phone"],
        saldo: json["saldo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        woocommerceClienteId: json["woocommerce_cliente_id"],
        notificationToken: json["notification_token"],
        firebase: json["firebase"],
        urlFirebase: json["urlFirebase"],
        qbId: json["QB_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "last_name2": lastName2,
        "email": email,
        "password": password,
        "address": address,
        "phone": phone,
        "saldo": saldo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image": image,
        "woocommerce_cliente_id": woocommerceClienteId,
        "notification_token": notificationToken,
        "firebase": firebase,
        "urlFirebase": urlFirebase,
        "QB_id": qbId,
    };
}

class SalesDetail {
    int? id;
    String? price;
    int? quantity;
    int? saleId;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic customerId;
    dynamic lotId;
    int? scanned;
    dynamic cajas;
    int? presentacionesId;
    SalesDetailProduct? product;

    SalesDetail({
        this.id,
        this.price,
        this.quantity,
        this.saleId,
        this.createdAt,
        this.updatedAt,
        this.customerId,
        this.lotId,
        this.scanned,
        this.cajas,
        this.presentacionesId,
        this.product,
    });

    factory SalesDetail.fromJson(Map<String, dynamic> json) => SalesDetail(
        id: json["id"],
        price: json["price"],
        quantity: json["quantity"],
        saleId: json["sale_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerId: json["CustomerID"],
        lotId: json["lot_id"],
        scanned: json["scanned"],
        cajas: json["cajas"],
        presentacionesId: json["presentaciones_id"],
        product: SalesDetailProduct.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "quantity": quantity,
        "sale_id": saleId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "CustomerID": customerId,
        "lot_id": lotId,
        "scanned": scanned,
        "cajas": cajas,
        "presentaciones_id": presentacionesId,
        "product": product,
    };
}

class SalesDetailProduct {
    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? productsId;
    int? sizesId;
    String? barcode;
    String? stockBox;
    String? alerts;
    String? stockItems;
    String? price;
    String? tieneKey;
    String? keyProduct;
    ProductProduct? product;

    SalesDetailProduct({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.productsId,
        this.sizesId,
        this.barcode,
        this.stockBox,
        this.alerts,
        this.stockItems,
        this.price,
        this.tieneKey,
        this.keyProduct,
        this.product,
    });

    factory SalesDetailProduct.fromJson(Map<String, dynamic> json) => SalesDetailProduct(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productsId: json["products_id"],
        sizesId: json["sizes_id"],
        barcode: json["barcode"],
        stockBox: json["stock_box"],
        alerts: json["alerts"],
        stockItems: json["stock_items"],
        price: json["price"],
        tieneKey: json["TieneKey"],
        keyProduct: json["KeyProduct"],
        product: ProductProduct.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "products_id": productsId,
        "sizes_id": sizesId,
        "barcode": barcode,
        "stock_box": stockBox,
        "alerts": alerts,
        "stock_items": stockItems,
        "price": price,
        "TieneKey": tieneKey,
        "KeyProduct": keyProduct,
        "product": product,
    };
}

class ProductProduct {
    int? id;
    String? name;
    String? barcode;
    int? saborId;
    String? cost;
    String? price;
    int? stock;
    int? alerts;
    String? image;
    int? categoryId;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? descripcion;
    String? estado;
    String? estaEnWoocomerce;
    String? tieneKey;
    String? keyProduct;
    int? userId;
    String? visible;
    int? tam1;
    int? tam2;
    String? pricePublic;
    int? sizeId;
    int? qbId;
    dynamic libraConsumo1;
    dynamic libraConsumo2;

    ProductProduct({
        this.id ,
        this.name,
        this.barcode,
        this.saborId,
        this.cost,
        this.price,
        this.stock,
        this.alerts,
        this.image,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.descripcion,
        this.estado,
        this.estaEnWoocomerce,
        this.tieneKey,
        this.keyProduct,
        this.userId,
        this.visible,
        this.tam1,
        this.tam2,
        this.pricePublic,
        this.sizeId,
        this.qbId,
        this.libraConsumo1,
        this.libraConsumo2,
    });

    factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        saborId: json["sabor_id"],
        cost: json["cost"],
        price: json["price"],
        stock: json["stock"],
        alerts: json["alerts"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        descripcion: json["descripcion"],
        estado: json["estado"],
        estaEnWoocomerce: json["EstaEnWoocomerce"],
        tieneKey: json["TieneKey"],
        keyProduct: json["KeyProduct"],
        userId: json["user_id"],
        visible: json["visible"],
        tam1: json["tam1"],
        tam2: json["tam2"],
        pricePublic: json["price_public"],
        sizeId: json["size_id"],
        qbId: json["QB_id"],
        libraConsumo1: json["libra_consumo_1"],
        libraConsumo2: json["libra_consumo_2"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "sabor_id": saborId,
        "cost": cost,
        "price": price,
        "stock": stock,
        "alerts": alerts,
        "image": image,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "descripcion": descripcion,
        "estado": estado,
        "EstaEnWoocomerce": estaEnWoocomerce,
        "TieneKey": tieneKey,
        "KeyProduct": keyProduct,
        "user_id": userId,
        "visible": visible,
        "tam1": tam1,
        "tam2": tam2,
        "price_public": pricePublic,
        "size_id": sizeId,
        "QB_id": qbId,
        "libra_consumo_1": libraConsumo1,
        "libra_consumo_2": libraConsumo2,
    };
}
