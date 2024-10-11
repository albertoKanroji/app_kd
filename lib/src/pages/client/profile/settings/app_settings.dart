import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class ClientSettingsPage extends StatelessWidget {
  const ClientSettingsPage({super.key});

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
          'App Settings',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
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
    backgroundColor:Theme.of(context)
                        .colorScheme
                        .primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                onTap: () {
                  //Get.to(ClientDatosPage());
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'More settings soon',
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
             onPressed: () {
                      AdaptiveTheme.of(context).toggleThemeMode(); 
                      if (kDebugMode) {
                    print('se cambio de tema ');
                  }
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                // Configura el color de fondo del botón según el tema actual
                // primary: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.black : Colors.white,
              ),
              child: Text(
                // Cambiar el texto del botón según el tema actual
                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? 'Change white theme'
                    : 'Change dark theme',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  // Configura el color del texto según el tema actual
                  color:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
