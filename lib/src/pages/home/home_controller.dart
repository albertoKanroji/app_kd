import 'package:kd_latin_food/src/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController{
  User user=User.fromJson(GetStorage().read('user')??{});

 
void goToAddress() {
    Get.toNamed('/home/profile/address');
  }
  HomeController(){
    if (kDebugMode) {
      print('Usuario en Sesion: ${user.toJson()}');
    }
  }
  void singOut (){
    GetStorage().remove('user');
    Get.snackbar('Log out. ','');
    Get.offNamedUntil('/login', (route) => false);
  }
}

