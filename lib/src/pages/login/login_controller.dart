// ignore_for_file: avoid_print

import 'package:kd_latin_food/src/models/response_api.dart';
import 'package:kd_latin_food/src/providers/users_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  UsersProviders usersProviders = UsersProviders();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void goToAdmin() {
    Get.toNamed('/loginAdmin');
  }

  void login() async {
    GetStorage().remove('user');
    print("sesion anterior borrada");
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (kDebugMode) {
      print('Email:  $email');
    }
    if (kDebugMode) {
      print('Password: $password');
    }

    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProviders.login(email, password);
      if (kDebugMode) {
        print(responseApi.toJson());
      }
      if (responseApi.success == true) {
        GetStorage().write('user', responseApi.data);
        GetStorage().write('isAdmin', false);
        print("nueva sesion guardada");
        goToHomePage(
            userId:
                responseApi.data['id']); // Pasa el userId a la página principal
        Get.snackbar(
          'WELCOME',
          email,
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
      if (responseApi.success == false) {
        Get.snackbar(
          'User or password incorrect',
          'Try Again',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
    }
  }

  void loginAdmin() async {
    GetStorage().remove('user');
    print("sesion anterior borrada de admin");
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (kDebugMode) {
      print('Email:  $email');
    }
    if (kDebugMode) {
      print('Password: $password');
    }

    if (isValidForm(email, password)) {
      ResponseApi responseApi =
          await usersProviders.loginAdmin(email, password);
      if (kDebugMode) {
        print(responseApi.toJson());
      }
      if (responseApi.success == true) {
        GetStorage().write('user', responseApi.data);
        GetStorage().write('isAdmin', true);
        GetStorage().write('user', {
          'name': responseApi.data['name'],
          'email': responseApi.data['email'],
          'phone': responseApi.data['phone']
        });

        Map<String, dynamic>? userData = GetStorage().read('user');
        if (userData != null) {
          String name = userData['name'];
          String email = userData['email'];
          String phone = userData['phone'];

          // Ahora puedes usar estos datos en tu aplicación
          print('Nombre del usuario: $name');
          print('Correo electrónico del usuario: $email');
          print('Teléfono del usuario: $phone');
        }

        goToAdminPedidos(); // Pasa el userId a la página principal
        Get.snackbar(
          'WELCOME',
          email,
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
      if (responseApi.success == false) {
        Get.snackbar(
          'User or password incorrect',
          'Try again',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
    }
  }

  void goToHomePage({int? userId}) {
    // Pasa el userId a la página principal
    Get.offNamedUntil('/home', (route) => false, arguments: userId);
  }

  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  bool isValidForm(String email, String password) {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email not valid',
        'send an valid email',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
      return false;
    }
    if (email.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu email');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu Contraseña');
      return false;
    }
    return true;
  }
}
