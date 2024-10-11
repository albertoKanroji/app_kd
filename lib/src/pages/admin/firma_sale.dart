// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:kd_latin_food/src/models/order.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart'; // Importa el paquete de firma
import 'dart:convert';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';

class SaleDetailPageFirma extends StatefulWidget {
  final OrderData sale;
  final List<SalesDetail> saleDetails;

  const SaleDetailPageFirma(
      {super.key, required this.sale, required this.saleDetails});

  @override
  // ignore: library_private_types_in_public_api
  _SaleDetailPageFirmaState createState() => _SaleDetailPageFirmaState();
}

class _SaleDetailPageFirmaState extends State<SaleDetailPageFirma> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5, // Ancho del trazo del lápiz
    penColor:
        const Color.fromARGB(255, 16, 16, 16), // Color del trazo del lápiz
  );
  bool showSignaturePad = false; // Para mostrar u ocultar el Signature Pad
  Future<void> _printTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    try {
      // Encabezado de la empresa
      bytes += generator.text('K & D Latin Food',
          styles: const PosStyles(
              align: PosAlign.center, bold: true, height: PosTextSize.size2));
      bytes += generator.text('7341 NW 79th Terrace',
          styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text('Miami, FL 33166',
          styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text('Tel: 786-502-3953',
          styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text('Email: kdlatinfood@gmail.com',
          styles: const PosStyles(align: PosAlign.center));
      bytes += generator.hr(); // Línea separadora

      // Detalles del pedido
      bytes += generator.text('Invoice: ${widget.sale.id}',
          styles: const PosStyles(align: PosAlign.left, bold: true));
      bytes += generator.text('Date: ${widget.sale.fecha_escaneo}',
          styles: const PosStyles(align: PosAlign.left));
      bytes += generator.hr(); // Línea separadora

      // Detalles del cliente
      bytes += generator.text('${widget.sale.customer!.name}',
          styles: const PosStyles(align: PosAlign.left, bold: true));
      bytes += generator.text('${widget.sale.customer!.address}',
          styles: const PosStyles(align: PosAlign.left));
      bytes += generator.text('Terms: DUE ON RECEIPT',
          styles: const PosStyles(align: PosAlign.left));
      bytes += generator.hr(); // Línea separadora

      // Título de la factura
      bytes += generator.text('FINAL INVOICE',
          styles: const PosStyles(
              align: PosAlign.center, bold: true, height: PosTextSize.size2));
      bytes += generator.hr(); // Línea separadora

      // Cabecera de la tabla de productos
      bytes += generator.row([
        PosColumn(
            text: 'PRODUCT',
            width: 6,
            styles: const PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: 'QTY',
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: 'PRICE',
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: 'TOTAL',
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      // Imprimir detalles de cada producto en formato tabla
      for (var detail in widget.saleDetails) {
        final product = detail.product!.product!;
        double price = double.tryParse(detail.price ?? '0') ?? 0.0;

        bytes += generator.row([
          PosColumn(
              text: product.name!,
              width: 6,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '${detail.quantity}',
              width: 2,
              styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: '\$${price.toStringAsFixed(2)}',
              width: 2,
              styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: '\$${(detail.quantity! * price).toStringAsFixed(2)}',
              width: 2,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      bytes += generator.hr(); // Línea separadora

      // Totales
      bytes += generator.row([
        PosColumn(
            text: 'SALES:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: '\$${widget.sale.total}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'NET AMOUNT:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: '\$${widget.sale.total}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'DISCOUNT:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text: '\$0.00',
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'SALES TAX:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text: '\$0.00',
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'TOTAL DUE:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: '\$${widget.sale.total}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right, bold: true)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'TOTAL PAYMENT:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text: '\$0.00',
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes += generator.row([
        PosColumn(
            text: 'INVOICE BALANCE:',
            width: 6,
            styles: const PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: '\$${widget.sale.total}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right, bold: true)),
      ]);

      bytes += generator.hr(); // Línea separadora
      bytes += generator.feed(1); // Espacio final

      // Obtener los bytes de la firma si está presente
      if (_controller.isNotEmpty) {
        final signature = await _controller.toPngBytes();
        if (signature != null) {
          final img.Image? image = img.decodeImage(signature);
          if (image != null) {
            bytes += generator.text('Signature:',
                styles: const PosStyles(align: PosAlign.left, bold: true));
            bytes += generator.image(image);
          }
        }
      } else {
        bytes += generator.text('Firma: (No proporcionada)',
            styles: const PosStyles(align: PosAlign.left, bold: true));
      }

      bytes += generator.feed(2); // Espacio final en el ticket

      // Enviar los bytes a la impresora
      await BluetoothThermalPrinter.writeBytes(bytes);
    } catch (e) {
      // Si ocurre un error, lo enviamos al servidor
      await _sendErrorToServer(e.toString());
    }
  }

  Future<void> _printTicketWithZPL() async {
    try {
      // Ejemplo de comando ZPL simple para configurar el papel e imprimir el encabezado y los detalles del pedido
      String zplData = """
    ^XA
    ^MNY
    ^PW812  
    ^LL1200 

    ^CF0,30
    ^FO50,50^FDK & D Latin Food^FS
    ^CF0,20
    ^FO50,100^FD7341 NW 79th Terrace^FS
    ^FO50,130^FDMiami, FL 33166^FS
    ^FO50,160^FDTel: 786-502-3953^FS
    ^FO50,190^FDEmail: kdlatinfood@gmail.com^FS
    ^FO50,220^FD--------------------------------------------^FS
    ^CF0,25
    ^FO50,250^FDInvoice: ${widget.sale.id}^FS
    ^FO50,280^FDDate: ${widget.sale.fecha_escaneo}^FS
    ^FO50,310^FD--------------------------------------------^FS
    """;

      // Agrega los detalles de los productos
      int yOffset = 340;
      for (var detail in widget.saleDetails) {
        final product = detail.product!.product!;
        double price = double.tryParse(detail.price ?? '0') ?? 0.0;

        zplData += """
      ^CF0,25
      ^FO50,$yOffset^FD${product.name!}^FS
      ^FO50,${yOffset + 30}^FDQty: ${detail.quantity}  Price: \$${price.toStringAsFixed(2)}  Total: \$${(detail.quantity! * price).toStringAsFixed(2)}^FS
      ^FO50,${yOffset + 60}^FD--------------------------------------------^FS
      """;

        yOffset += 90;
      }

      // Finaliza el comando ZPL
      zplData += "^XZ";

      // Enviar los datos ZPL a la impresora
      await BluetoothThermalPrinter.writeBytes(utf8.encode(zplData));
    } catch (e) {
      // Si ocurre un error, lo enviamos al servidor
      await _sendErrorToServer(e.toString());
    }
  }

  Future<void> _printTestTicket() async {
    try {
      String zplData = '''
    ^XA
    ^MNY
    ^FO50,50^ADN,36,20^FDHola Mundo^FS
    ^XZ
''';

      await BluetoothThermalPrinter.writeBytes(utf8.encode(zplData));
       await _printTicketWithZPL();
    } catch (e) {
      await _sendErrorToServer(e.toString());
    }
  }

  Future<void> _sendErrorToServer(String error) async {
    final url =
        Uri.parse('https://kdlatinfood.com/intranet/public/api/save-error');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'trace_error': error}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Error enviado al servidor correctamente.');
        }
      } else {
        if (kDebugMode) {
          print('Error al enviar al servidor: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al intentar enviar el error al servidor: $e');
      }
    }
  }

  // Función para generar la imagen del ticket y guardarla en el almacenamiento
  Future<void> _generateTicketImage() async {
    // Ajustar tamaño de la imagen para un formato de ticket más largo
    img.Image ticketImage = img.Image(400, 800); // Aumenté la altura

    // Dibuja un fondo blanco
    img.fill(ticketImage, img.getColor(255, 255, 255));

    // Encabezado de la empresa
    img.drawString(ticketImage, img.arial_24, 10, 20, 'K & D Latin Food');
    img.drawString(ticketImage, img.arial_14, 10, 50, '7341 NW 79th Terrace');
    img.drawString(ticketImage, img.arial_14, 10, 70, 'Miami, FL 33166');
    img.drawString(ticketImage, img.arial_14, 10, 90, 'Tel: 786-502-3953');
    img.drawString(
        ticketImage, img.arial_14, 10, 110, 'Email: kdlatinfood@gmail.com');

    // Agregar una línea divisora
    img.drawLine(ticketImage, 10, 130, 390, 130, img.getColor(0, 0, 0));

    // Detalles del pedido
    img.drawString(
        ticketImage, img.arial_24, 10, 140, 'Invoice: ${widget.sale.id}');
    img.drawString(ticketImage, img.arial_14, 10, 160,
        'Date: ${widget.sale.fecha_escaneo}');
    img.drawString(ticketImage, img.arial_14, 10, 180, 'Driver Name: ');
    img.drawString(ticketImage, img.arial_14, 10, 200, 'Salesman: ');

    // Agregar una línea divisora
    img.drawLine(ticketImage, 10, 220, 390, 220, img.getColor(0, 0, 0));

    // Detalles del cliente
    img.drawString(
        ticketImage, img.arial_24, 10, 230, '${widget.sale.customer!.name}');
    img.drawString(
        ticketImage, img.arial_14, 10, 250, '${widget.sale.customer!.address}');
    img.drawString(ticketImage, img.arial_14, 10, 290, 'Terms: DUE ON RECEIPT');

    // Agregar una línea divisora
    img.drawLine(ticketImage, 10, 310, 390, 310, img.getColor(0, 0, 0));

    // Título de la factura final
    img.drawString(ticketImage, img.arial_24, 10, 320, 'FINAL INVOICE');

    // Cabecera de la tabla de productos
    img.drawString(ticketImage, img.arial_14, 10, 340, 'PRODUCT');
    img.drawString(ticketImage, img.arial_14, 200, 340, 'QTY');
    img.drawString(ticketImage, img.arial_14, 250, 340, 'PRICE');
    img.drawString(ticketImage, img.arial_14, 320, 340, 'TOTAL');

    int yOffset = 360;

    // Agregar los detalles de cada producto en formato tabla
    for (var detail in widget.saleDetails) {
      final product = detail.product!.product!;

      // Conversión de String? a double para el precio
      double price = double.tryParse(detail.price ?? '0') ?? 0.0;
      img.drawString(ticketImage, img.arial_14, 10, yOffset, product.name!);
      img.drawString(
          ticketImage, img.arial_14, 200, yOffset, detail.quantity.toString());
      img.drawString(
          ticketImage, img.arial_14, 250, yOffset, '\$${detail.price}');
      img.drawString(ticketImage, img.arial_14, 320, yOffset,
          '\$${(detail.quantity! * price).toStringAsFixed(2)}');
      yOffset += 20;
    }

    // Agregar una línea divisora antes de los totales
    img.drawLine(ticketImage, 10, yOffset + 10, 390, yOffset + 10,
        img.getColor(0, 0, 0));
    yOffset += 30;

    // Totales
    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'SALES:');
    img.drawString(
        ticketImage, img.arial_14, 320, yOffset, '\$${widget.sale.total}');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'NET AMOUNT:');
    img.drawString(
        ticketImage, img.arial_14, 320, yOffset, '\$${widget.sale.total}');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'DISCOUNT:');
    img.drawString(ticketImage, img.arial_14, 320, yOffset, '\$0.00');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'SALES TAX:');
    img.drawString(ticketImage, img.arial_14, 320, yOffset, '\$0.00');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'TOTAL DUE:');
    img.drawString(
        ticketImage, img.arial_14, 320, yOffset, '\$${widget.sale.total}');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'TOTAL PAYMENT:');
    img.drawString(ticketImage, img.arial_14, 320, yOffset, '\$0.00');
    yOffset += 20;

    img.drawString(ticketImage, img.arial_14, 10, yOffset, 'INVOICE BALANCE:');
    img.drawString(
        ticketImage, img.arial_14, 320, yOffset, '\$${widget.sale.total}');
    yOffset += 40; // Espacio antes de la firma

    // Agregar firma si está presente
    if (_controller.isNotEmpty) {
      final signature = await _controller.toPngBytes();
      if (signature != null) {
        final img.Image? signatureImage = img.decodeImage(signature);
        if (signatureImage != null) {
          img.drawString(ticketImage, img.arial_14, 10, yOffset, 'Signature:');
          img.copyInto(ticketImage, signatureImage,
              dstX: 10, dstY: yOffset + 20);
          yOffset += signatureImage.height + 40;
        }
      }
    }

    // Guarda la imagen en el almacenamiento del dispositivo
    await _saveImage(ticketImage);
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      } else {
        // Verifica si estamos en Android 11 o superior
        if (await Permission.manageExternalStorage.isGranted) {
          return true;
        }

        // Solicitar permisos dependiendo de la versión de Android
        if (Platform.isAndroid &&
            (await Permission.manageExternalStorage.request().isGranted)) {
          return true;
        } else if (await Permission.storage.request().isGranted) {
          return true;
        }
      }
    }
    return false;
  }

  // Función para guardar la imagen en el almacenamiento local
  Future<void> _saveImage(img.Image image) async {
    if (await _requestStoragePermission()) {
      try {
        // Obtén el directorio donde guardar la imagen
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/ticket_image.png';

        // Convierte la imagen a formato PNG y guarda el archivo
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(img.encodePng(image)); // Guardar primero

        // Mostrar confirmación después de guardar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket guardado en: $imagePath')),
        );

        // Abrir el archivo una vez que se ha guardado
        await OpenFile.open(imagePath);
      } catch (e) {
        if (kDebugMode) {
          print('Error al guardar la imagen: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('Permiso denegado para acceder al almacenamiento');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permiso denegado para acceder al almacenamiento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void goToAdminPedidos() {
      Get.toNamed('/homeadmin');
    }

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
          'Order detail',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Order ID: ${widget.sale.id}',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${widget.sale.total}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          'Total Items: ${widget.sale.items}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Order Status: ${widget.sale.status}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Fecha Escaneo: ${widget.sale.fecha_escaneo}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Shipment Status: ${widget.sale.statusEnvio}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 24.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Products in Order',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                    height:
                        16.0), // Espacio entre detalles y lista de productos
                const Text('Products in the Order',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.saleDetails.length,
                    itemBuilder: (context, index) {
                      final detail = widget.saleDetails[index];
                      final product = detail.product;

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: SizedBox(
                            width: 80,
                            height: 80,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://kdlatinfood.com/intranet/public/storage/products/${detail.product!.product!.image ?? ""}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                          title: Text(
                            product!.product!.name!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${detail.price}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Amount: ${detail.quantity} cajas \nSKU: ${detail.product!.barcode}\nSize: ${_getSizeText(detail.product!.sizesId)}',
                                style: const TextStyle(fontSize: 16.0),
                              ),

                              // Agrega más detalles del producto si es necesario.
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Mostrar el Signature Pad y los botones solo si showSignaturePad es verdadero
                if (showSignaturePad)
                  Column(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Alinea el contenido en la parte superior
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            bottom:
                                20.0), // Espacio opcional en la parte inferior del Container
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 2.0), // Cambia el color de los bordes
                          borderRadius: BorderRadius.circular(
                              10.0), // Opcional: agrega esquinas redondeadas
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Signature(
                                controller: _controller,
                                width:
                                    290, // Ajusta el tamaño de Signature para que quepa dentro del borde
                                height: 190,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color:
                                    Colors.white, // Fondo blanco para el texto
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Firme aquí',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // _generateTicketImage();
                              // Verificar si la impresora está conectada
                              String? isConnected =
                                  await BluetoothThermalPrinter
                                      .connectionStatus;

                              if (isConnected != "true") {
                                // Mostrar un mensaje si no hay impresora conectada
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Error de conexión'),
                                      content: const Text(
                                          'Conecta una impresora para continuar.'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Mostrar un diálogo de carga mientras se procesa la solicitud
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );

                                // Realizar la petición API cuando se confirma la entrega
                                final apiUrl = Uri.parse(
                                    'https://kdlatinfood.com/intranet/public/api/sales/FIN/${widget.sale.id}');

                                try {
                                  final response = await http.put(apiUrl);

                                  // Cerrar el diálogo de carga
                                  Navigator.of(context).pop();

                                  // Imprimir el ticket si hay impresora conectada
                                  // await _printTicket();
                                  //  await _printTicketWithZPL();
                                  await _printTestTicket();
                                   await _printTicketWithZPL();
                                 
                                  

                                  // Muestra un cuadro de diálogo de "Completado" si la respuesta es 200
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Completado'),
                                        content: const Text(
                                            'Pedido completado e impreso con éxito.'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                color: AdaptiveTheme.of(context)
                                                            .mode ==
                                                        AdaptiveThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              goToAdminPedidos();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } catch (e) {
                                  // Manejar errores de conexión aquí
                                  Navigator.of(context)
                                      .pop(); // Cerrar el diálogo de carga
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'Error de conexión al completar la venta.'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xE5FF5100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),

                          const SizedBox(width: 20), // Espacio entre botones
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CupertinoButton(
        onPressed: () {
          // Cambiar el estado para mostrar el Signature Pad cuando se presiona "Entregar"
          setState(() {
            showSignaturePad = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color:
                const Color(0xE5FF5100), // Cambia el color según tu preferencia
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: const Text(
            'Deliver',
            style: TextStyle(
              color: Colors
                  .white, // Cambia el color del texto según tu preferencia
            ),
          ),
        ),
      ),
    );
  }
}

String _getSizeText(int? sizesId) {
  switch (sizesId) {
    case 1:
      return 'GRANDE';
    case 2:
      return 'MEDIANO';
    case 3:
      return 'PEQUEÑO';
    default:
      return 'TAMAÑO DESCONOCIDO';
  }
}
