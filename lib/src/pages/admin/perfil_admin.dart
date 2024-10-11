import 'dart:convert';

import 'package:kd_latin_food/src/pages/admin/printer_service.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:kd_latin_food/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zebra_printer/zebra_printer.dart';
import 'package:http/http.dart' as http;

class PerfilAdmin extends StatefulWidget {
  PerfilAdmin({super.key});

  @override
  State<PerfilAdmin> createState() => _PerfilAdminState();
}

class _PerfilAdminState extends State<PerfilAdmin> {
  List _devicesList = [];
  bool connected = false;
  PrinterService printerService = PrinterService();
  final ZebraPrinter _zebraPrinterPlugin = ZebraPrinter();
  int batteryLevel = 0;
  String printerName = '';
  String selectedMacAddress =
      ''; // Variable para almacenar la dirección MAC seleccionada
  bool printerConnection = false;
  final TextEditingController controlleZpl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controlleZpl.text =
        """^XA^FO50,50^A0N,50,50^FDHola Mundo^FS^XZ"""; // Ejemplo ZPL
  }

  void searchDevices() async {
    await requestBluetoothPermissions(); // Solicita los permisos de Bluetooth

    printerService.getBluetooth().then((value) {
      setState(() {
        _devicesList = printerService.getAvailableDevices();
      });
      if (_devicesList.isEmpty) {
        showSnackBar('No se encontraron dispositivos');
      }
    });
  }

  Future<void> requestBluetoothPermissions() async {
    // Verifica si los permisos ya han sido otorgados
    if (await Permission.bluetooth.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      // Los permisos están otorgados, puedes proceder
      return;
    }

    // Solicita los permisos
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    // Verifica si los permisos fueron otorgados
    if (statuses[Permission.bluetooth]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.location]!.isGranted) {
      // Todos los permisos fueron otorgados
    } else {
      // Algunos permisos no fueron otorgados, maneja el error
      showSnackBar(
          'No se otorgaron todos los permisos necesarios para Bluetooth o ubicación.');
    }
  }

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        margin: const EdgeInsets.all(50),
        elevation: 1,
        duration: const Duration(milliseconds: 8000),
        backgroundColor: const Color(0xFF08919C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void printerConnect(int index) async {
    String select = _devicesList[index];
    List<String> list = select.split("#");
    String deviceName = list[0]; // Nombre del dispositivo
    String macAddress = list[1]; // Dirección MAC del dispositivo

    try {
      // Intentar conectar al dispositivo
      await printerService.setConnect(macAddress).then((value) {
        setState(() {
          connected = printerService.getConnectedState();
          printerName = deviceName;
          selectedMacAddress = macAddress; // Guardar la MAC seleccionada
        });

        // Mostrar información solo si está conectado
        if (connected) {
           showSnackBar('Conectado a dispositivo: $deviceName');
          showSnackBar('Conectado a dispositivo:');
          showSnackBar('Nombre: $deviceName');
          showSnackBar('MAC: $macAddress');
        } else {
          showSnackBar('Error al conectar con el dispositivo: $deviceName');
        }
      });

      // Obtener nivel de batería
      await printerService.getPrinterBatteryLevel().then((value) {
        setState(() {
          batteryLevel = printerService.batteryLevel;
        });

        if (connected) {
          showSnackBar('Nivel de batería: $batteryLevel%');
        }
      });
    } catch (e) {
      // Muestra el error específico si la conexión falla
      showSnackBar('Error durante la conexión con el dispositivo: $e');
    }
  }

  // Función para imprimir ZPL usando el plugin de Zebra
  void printZPL() {
    if (connected && selectedMacAddress.isNotEmpty) {
      String zplData = controlleZpl.text =
          """^XA^FO50,50^A0N,50,50^FDHola Mundo^FS^XZ"""; 

      _zebraPrinterPlugin
          .printZPLOverBluetooth(
        macAddress: selectedMacAddress,
        data: zplData, 
      )
          .then((value) {
        if (kDebugMode) {
          showSnackBar('Impresión completada: $value');
        }
        showSnackBar('Impresión completada');
      }).catchError((error) {
        if (kDebugMode) {
         // _sendErrorToServer(error);

          
        }
        showSnackBar('Error en la impresión: $error');
        showSnackBar('Error en la impresión');
      });
    } else {
      showSnackBar('No hay impresora conectada');
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userData = GetStorage().read('user');
    String name = userData?['name'] ?? 'Nombre no disponible';
    String email = userData?['email'] ?? 'Correo electrónico no disponible';
    var widthScreen = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(65.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60.0,
                        backgroundImage: CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923'),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          con1.singOut();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xE5FF5100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: widthScreen,
                child: ElevatedButton(
                  onPressed: searchDevices,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 17),
                    backgroundColor: const Color(0xFF00398f),
                  ),
                  child: const Text('Buscar dispositivos'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                height: 200,
                child: ListView.builder(
                  itemCount: _devicesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        printerConnect(index);
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _devicesList[index].toString().split('#')[0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _devicesList[index]
                                          .toString()
                                          .split('#')[0] ==
                                      printerName
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            _devicesList[index].toString().split('#')[1],
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      subtitle: Text(
                        _devicesList[index].toString().split('#')[0] ==
                                printerName
                            ? 'Conectado'
                            : "Clic para conectar",
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Botón para imprimir el ZPL
              SizedBox(
                width: widthScreen,
                child: ElevatedButton(
                  onPressed: connected ? printZPL : null,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 17),
                    backgroundColor: const Color(0xFF08919C),
                  ),
                  child: const Text('Imprimir ZPL'),
                ),
              ),
              const SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //     AdaptiveTheme.of(context).toggleThemeMode();
              //     if (kDebugMode) {
              //       print('se cambio de tema ');
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.white,
              //     backgroundColor: const Color(0xE5FF5100),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20.0),
              //     ),
              //     textStyle: const TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     minimumSize: const Size(120, 40),
              //   ),
              //   child: Text(
              //     AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
              //         ? 'Change white theme'
              //         : 'Change dark theme',
              //     style: const TextStyle(
              //       fontSize: 16,
              //       height: 1.5,
              //       fontFamily: 'Inter',
              //       fontWeight: FontWeight.w600,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
