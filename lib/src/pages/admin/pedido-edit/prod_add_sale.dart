// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:kd_latin_food/src/models/new/producto_new_key.dart';
import 'package:kd_latin_food/src/models/order.dart';
import 'package:kd_latin_food/src/pages/admin/pedido-edit/controller.dart';
import 'package:kd_latin_food/src/pages/admin/sale_detail_cargar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProdcutSalePage extends StatefulWidget {
  final SaleEditController con = Get.put(SaleEditController());
  final OrderData sale;
  final List<SalesDetail> saleDetails;

  AddProdcutSalePage({Key? key, required this.sale, required this.saleDetails})
      : super(key: key);

  @override
  _SaleEditPageState createState() => _SaleEditPageState();
}

class _SaleEditPageState extends State<AddProdcutSalePage> {
  TextEditingController quantityController = TextEditingController();

  int quantity = 1;
  PresentacionKey? selectedProduct;
  PresentacionKey? selectedProduct1;
  @override
  void initState() {
    super.initState();
    widget.con.fetchSales();
    widget.con.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
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
          'Add Product #${widget.sale.id}', // Agrega el ID del pedido aquí
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
      backgroundColor: Colors.white,
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
                DropdownButton<String>(
                  value: selectedProduct1
                      ?.producto.name!, // Aquí se usa el nombre del producto como valor
                  items: widget.con.products.map((PresentacionKey product) {
                    return DropdownMenuItem<String>(
                      value: product
                          .producto.name!, // Aquí se establece el nombre como valor
                      child: SizedBox(
                        width: 270,
                        height: 90,
                        child: Text(
                          "${product.barcode!} - ${product.producto.name!}",
                          overflow: TextOverflow
                              .ellipsis, // Trunca el texto con tres puntos suspensivos
                          maxLines: 2, // Limita el texto a una línea
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Actualiza el producto seleccionado
                    setState(() {
                      selectedProduct1 = widget.con.products.firstWhere(
                        (product) => product.producto.name == newValue,
                      );
                    });

                    print(selectedProduct1?.producto.name);
                    print(selectedProduct1?.barcode);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                  onChanged: (String value) {
                    // Actualiza la cantidad
                    quantity = int.tryParse(value) ?? 0;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Llama a la función para agregar el producto a la venta
                        await widget.con.addProductToSale(
                          saleId: widget.sale.id!,
                          barcode: selectedProduct1!.barcode!,
                          quantity: quantity,
                        );
                        quantityController.clear();
                        widget.con.loadProducts();
                        setState(() {});
                        Get.toNamed('/homeadmin');
                        
                        await Future.delayed(const Duration( milliseconds  :200)); // Ajusta el tiempo según tu necesidad
                       
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SaleDetailPage(
                              sale: widget.sale,
                              saleDetails: widget.saleDetails,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color(0xE5FF5100), // Color del texto blanco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              19.0), // Esquinas redondeadas
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
