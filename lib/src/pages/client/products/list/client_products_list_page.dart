import 'package:kd_latin_food/src/models/user.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/cart_detail.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/client_products_list_page.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:kd_latin_food/src/pages/envios/envios_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:kd_latin_food/src/utils/custom_animated_bottom_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'client_products_list_controller.dart';

// ignore: must_be_immutable
class ClientProductsListPage extends StatelessWidget {
  final ClientProductsListController con =
      Get.put(ClientProductsListController());

  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  User user = User.fromJson(GetStorage().read('user') ?? {});
  // ignore: use_key_in_widget_constructors
  ClientProductsListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final int? userId = user.id;

    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            ProductsListPage(customerId: userId!),
            // ignore: prefer_const_constructors
            CartPage(),
            ClientOrdersPage(customerId: userId),
            ClientProfileInfoPage(customerId: userId),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(
      () => CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: const Color(0xE5FF5100),
        showElevation: true,
        itemCornerRadius: 30,
        curve: Curves.ease,
        selectedIndex: con.indexTab.value,
        onItemSelected: (index) => con.changeTab(index),
        items: [
          BottomNavyBarItem(
            icon: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/kd-latinfood.appspot.com/o/K%26D%20blanco.png?alt=media&token=12348d16-6a5c-46ed-917d-6d1a35f6cdb3',
              width: 33,
              height: 33,
            ),
            title: const Text('Products'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.delivery_dining),
            title: const Text('My orders'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('My Profile'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
