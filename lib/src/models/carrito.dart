class CarritoResponse {
  final bool success;
  final List<CarritoItem> data;

  CarritoResponse({
    required this.success,
    required this.data,
  });

  factory CarritoResponse.fromJson(Map<String, dynamic> json) {
    return CarritoResponse(
      success: json['success'],
      data: List<CarritoItem>.from(
          json['data'].map((item) => CarritoItem.fromJson(item))),
    );
  }
}

class CarritoItem {
  final int id;
  final int idCliente;
  final int items;
  final String updatedAt;
  final String createdAt;
  final int presentacionesId;
  final Producto producto;
  final Cliente cliente;

  CarritoItem({
    required this.id,
    required this.idCliente,
    required this.items,
    required this.updatedAt,
    required this.createdAt,
    required this.presentacionesId,
    required this.producto,
    required this.cliente,
  });

  factory CarritoItem.fromJson(Map<String, dynamic> json) {
    return CarritoItem(
      id: json['id'],
      idCliente: json['id_cliente'],
      items: json['items'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      presentacionesId: json['presentaciones_id'],
      producto: Producto.fromJson(json['producto']),
      cliente: Cliente.fromJson(json['cliente']),
    );
  }
}

class Producto {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int productsId;
  final int sizesId;
  final String barcode;
  final String stockBox;
  final String alerts;
  final String stockItems;
  final String price;
  final String tieneKey;
  final String keyProduct;
  final ProductDetails product;

  Producto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.productsId,
    required this.sizesId,
    required this.barcode,
    required this.stockBox,
    required this.alerts,
    required this.stockItems,
    required this.price,
    required this.tieneKey,
    required this.keyProduct,
    required this.product,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productsId: json['products_id'],
      sizesId: json['sizes_id'],
      barcode: json['barcode'],
      stockBox: json['stock_box'],
      alerts: json['alerts'],
      stockItems: json['stock_items'],
      price: json['price'],
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
      product: ProductDetails.fromJson(json['product']),
    );
  }
}

class ProductDetails {
  final int id;
  final String name;
  final String image;
  final String price;

  ProductDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  // Método para convertir JSON a una instancia de ProductDetails
  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      price: json['price'],
    );
  }
}


class Cliente {
  final int id;
  final String name;
  final String lastName;
  final String? lastName2;
  final String email;
  final String address;
  final String phone;
  final int saldo;
  final String createdAt;
  final String updatedAt;
  final String image;
  final String? woocommerceClienteId;

  Cliente({
    required this.id,
    required this.name,
    required this.lastName,
    this.lastName2,
    required this.email,
    required this.address,
    required this.phone,
    required this.saldo,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    this.woocommerceClienteId,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      lastName2: json['last_name2'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      saldo: json['saldo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      woocommerceClienteId: json['woocommerce_cliente_id'],
    );
  }
}
