import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Necesario para abrir enlaces

class ClientPrivacy extends StatelessWidget {
  const ClientPrivacy({Key? key}) : super(key: key);

  // Método para abrir el enlace
  void _launchURL() async {
    final Uri _url = Uri.parse('https://kdlatinfood.com/privacy-policy/');

    try {
       final Uri url = Uri.parse('https://kdlatinfood.com/privacy-policy/');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $_url');
    }
    } catch (e) {
      // Manejo de errores aquí
      print('Error al abrir el navegador: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double fem = 1.0; // Replace with your desired value
    const double ffem = 1.0; // Replace with your desired value

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(''),
        centerTitle: true,
        elevation: 0,
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(1.5 * fem, 0.5, 0 * fem, 34 * fem),
              child: const Text(
                'Privacy and Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w600,
                  height: -5,
                  letterSpacing: -0.3333333433 * fem,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0.5 * fem, 0 * fem, 0 * fem, 8 * fem),
              constraints: const BoxConstraints(maxWidth: 319 * fem),
              child: const Text(
                'This Privacy Policy outlines the procedures and practices concerning the collection, usage, maintenance, and disclosure of information gathered from users ("User" or "Users") of the K&D Latin Food mobile application ("App") provided by K&D Latin food Inc.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.1725 * ffem / fem,
                  letterSpacing: -0.3333333433 * fem,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0.5 * fem, 0 * fem, 0 * fem, 6 * fem),
              constraints: const BoxConstraints(maxWidth: 319 * fem),
              child: const Text(
                'We are dedicated to safeguarding the privacy and security of your personal data, and we undertake to collect, utilize, and disclose information in conformity with this Privacy Policy and applicable data protection regulations. Your utilization of the App implies your acknowledgment and agreement to the terms and conditions laid out in this Privacy Policy. Please thoroughly review this Privacy Policy to comprehend how we handle your data and to understand your rights concerning it.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.1725 * ffem / fem,
                  letterSpacing: -0.3333333433 * fem,
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchURL, // Llamada al método para abrir el enlace
              child: const Text(
                'Read the full Privacy Policy here.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14 * ffem,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue, // Estilo de enlace (cambia el color si es necesario)
                  decoration: TextDecoration.underline, // Subraya el texto como un enlace
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
