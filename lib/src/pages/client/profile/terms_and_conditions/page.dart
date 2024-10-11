import 'package:flutter/material.dart';

class ClientTerms extends StatelessWidget {
  const ClientTerms({super.key});

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
       // backgroundColor: Colors.white,
        elevation: 0,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:
                  const EdgeInsets.fromLTRB(1.5 * fem, 0.5, 0 * fem, 34 * fem),
              child: const Text(
                'Terms And Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w600,
                  height: -5,
                  letterSpacing: -0.3333333433 * fem,
                  //color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(
                  0.5 * fem, 0 * fem, 0 * fem, 8 * fem),
              constraints: const BoxConstraints(maxWidth: 319 * fem),
              child: const Text(
                'By accessing and using our mobile application, you agree to abide by these terms and conditions. The App is provided by K&D Latin Food Inc for lawful purposes only, and its use is subject to compliance with these Terms. You are solely responsible for ensuring the security of your account credentials and for any activity conducted under your account. We reserve the right to modify, suspend, or terminate the App or your access to it at any time without prior notice.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.1725 * ffem / fem,
                  letterSpacing: -0.3333333433 * fem,
                //  color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(
                  0.5 * fem, 0 * fem, 0 * fem, 6 * fem),
              constraints: const BoxConstraints(maxWidth: 319 * fem),
              child: const Text(
                'Your continued use of the App following any changes to these Terms constitutes acceptance of those changes. Please review these Terms periodically for updates.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.1725 * ffem / fem,
                  letterSpacing: -0.3333333433 * fem,
                 // color: Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
