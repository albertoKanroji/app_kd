// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, unused_element, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:math';
import 'dart:ui';

import 'package:kd_latin_food/src/pages/client/products/prod/prod_new_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';

import 'package:kd_latin_food/main.dart';
import 'package:kd_latin_food/src/models/category.dart';
import 'package:kd_latin_food/src/models/product.dart';
import 'package:kd_latin_food/src/models/user.dart';
import 'package:kd_latin_food/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/check_out.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/client_products_list_controller.dart';
import 'package:kd_latin_food/src/pages/client/products/prod/favorite_controller.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';

class SizeController extends GetxController {
  RxString selectedSize = ''.obs;
}

// ignore: must_be_immutable
class ProductsListPage extends StatelessWidget {
  final RxList<Category> categories = RxList<Category>();
  final SelectedCategoryController selectedCategoryController =
      Get.put(SelectedCategoryController());

  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  final ProductsListController con = Get.put(ProductsListController());

  final ClientProductsListController con5 =
      Get.put(ClientProductsListController());
  final CartController cartController = Get.put(CartController());
  bool isFavorite = false;
  bool isAddToCartEnabled =
      false; // Variable para habilitar/deshabilitar el botón "Add to Cart"
  int selectedSizeMultiplier = 1; // Multiplicador del precio inicial

  final Map<int, int> selectedSizeMultipliers = {};
  double _generateRandomRating() {
    final random = Random();
    return (random.nextInt(51)) / 10;
  }

  ProductsListPage({super.key, required int customerId});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _favoriteController = Get.put(FavoritesController());
    final ProductsListController conG = Get.put(ProductsListController());
    final ProductsListController conF = Get.find();
    final ProductsListController productController =
        Get.put(ProductsListController());
    final SizeController sizeController = Get.put(SizeController());
    String selectedButton = "";
    final Map<int, String> selectedSizeMultipliers1 = {};

    CartItem? findCartItemByProduct(Product product) {
      // Busca el CartItem correspondiente al producto dado
      return cartController.cartItems
          .firstWhere((cartItem) => cartItem.product.id == product.id);
    }

    Widget buildBadge(String text) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA726), // Naranja
              Color(0xFFF57C00), // Naranja oscuro
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Color del texto
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    CartItem? findCartItemByProduct2(Product product) {
      // Busca el CartItem correspondiente al producto dado
      try {
        return cartController.cartItems
            .firstWhere((cartItem) => cartItem.product.id == product.id);
      } catch (_) {
        return null; // Retorna null si no se encuentra ningún CartItem
      }
    }

    int quantity = 1;
    final categoryIcons = {
      "04-Tequeños": Icons.abc_sharp,
      "03-Cachitos": Icons.access_alarm,
      "02-Pastelitos": Icons.add_home,
      "01-Empanadas": Icons.accessibility,
      "05-Mini Pan": Icons.account_box,
    };

    User user = User.fromJson(GetStorage().read('user') ?? {});
    final int? userId = user.id;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        // backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 10),
                child: Container(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Obx(() {
            return IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 32,
                  ),
                  if (cartController.cartItemCount > 0)
                    Positioned(
                      right: -1,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          '${cartController.cartItemCount}',
                          style: const TextStyle(
                            //  color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                con5.changeTab(1);
              },
            );
          }),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 223, 222, 222),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: const Color.fromARGB(255, 223, 222, 222)),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 18),
                ),
                onFieldSubmitted: (value) {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(con.products),
                    query: value,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: buildCategoriesList(),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Obx(() => DefaultTabController(
            length: 2,
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: const TabBar(
                      labelColor: Color(0xE5FF5100),
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blue,
                            width: 3.0,
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.ac_unit),
                          text: 'Raw',
                        ),
                        Tab(
                          icon: Icon(Icons.breakfast_dining_outlined),
                          text: 'Pre-Cooked',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Contenido de la pestaña de productos crudos
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dos columnas por fila
                          crossAxisSpacing:
                              5.0, // Espacio horizontal entre las tarjetas
                          mainAxisSpacing:
                              6.0, // Espacio vertical entre las tarjetas
                          childAspectRatio:
                              0.72, // Ajusta la proporción de las tarjetas
                        ),
                        itemCount: con.filteredProductsCrudos.length,
                        itemBuilder: (context, index) {
                          var product = con.filteredProductsCrudos[index];
                          return Stack(
                            children: [
                              // La tarjeta del producto
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Esquinas redondeadas
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Imagen del producto
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.image!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'SKU: ${product.barcode} \nBox: ${product.tam1} Units',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Precio
                                          Text(
                                            '\$${((product.tam1 ?? 1) * product.price!).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                          // Botón de detalle
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductoDetalleNPage(
                                                    product: product,
                                                    customerId: userId,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(
                                                        0xFFFFA726), // Naranja
                                                    Color(
                                                        0xFFF57C00), // Naranja oscuro
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 11.0,
                                                        vertical: 10.0),
                                                child: const Text(
                                                  'DETAIL',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                              // Las insignias redondas en la esquina superior derecha
                              Positioned(
                                top: 8,
                                //right: 8,
                                left: 8,
                                child: Row(
                                  children: [
                                    buildBadge("G"),
                                    const SizedBox(
                                        width: 4), // Espacio entre insignias
                                    buildBadge("M"),
                                    const SizedBox(width: 4),
                                    buildBadge("P"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // Contenido de la pestaña de productos precocidos
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dos columnas por fila
                          crossAxisSpacing:
                              5.0, // Espacio horizontal entre las tarjetas
                          mainAxisSpacing:
                              6.0, // Espacio vertical entre las tarjetas
                          childAspectRatio:
                              0.72, // Ajusta la proporción de las tarjetas
                        ),
                        itemCount: con.filteredProductsPreCocidos.length,
                        itemBuilder: (context, index) {
                          var product = con.filteredProductsPreCocidos[index];
                          return Stack(
                            children: [
                              // La tarjeta del producto
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Esquinas redondeadas
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Imagen del producto
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.image!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'SKU: ${product.barcode} \nBox: ${product.tam1} Units',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Precio
                                          Text(
                                            '\$${((product.tam1 ?? 1) * product.price!).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                          // Botón de detalle
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductoDetalleNPage(
                                                    product: product,
                                                    customerId: userId,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(
                                                        0xFFFFA726), // Naranja
                                                    Color(
                                                        0xFFF57C00), // Naranja oscuro
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 11.0,
                                                        vertical: 10.0),
                                                child: const Text(
                                                  'DETAIL',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                              // Las insignias redondas en la esquina superior derecha
                              Positioned(
                                top: 8,
                                //right: 8,
                                left: 8,
                                child: Row(
                                  children: [
                                    buildBadge("G"),
                                    const SizedBox(
                                        width: 4), // Espacio entre insignias
                                    buildBadge("M"),
                                    const SizedBox(width: 4),
                                    buildBadge("P"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      // floatingActionButton: Obx(() {
      //   final totalProducts = con.contadoresPorProducto.values
      //       .map<int>((value) => value.value as int) // Convertir a int
      //       .fold<int>(
      //         0,
      //         (sum, value) => sum + value,
      //       );

      //   return SizedBox(
      //     width: MediaQuery.of(context).size.width -
      //         60, // Ajusta según tus necesidades
      //     child: ElevatedButton(
      //       onPressed: cartController.cartItemCount > 0
      //           ? () {
      //               Navigator.push(
      //                 context,
      //                 PageTransition(
      //                   type: PageTransitionType.fade,
      //                   child: CheckOutPage(),
      //                 ),
      //               );
      //             }
      //           : null,
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: const Color(0xE5FF5100),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         padding: const EdgeInsets.symmetric(vertical: 12),
      //         minimumSize: Size(MediaQuery.of(context).size.width,
      //             0), // Ajusta según tus necesidades
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Text(
      //             'Place Order',
      //             style: TextStyle(
      //               fontSize: 16,
      //               height: 1,
      //               fontWeight: FontWeight.w500,
      //               color: Color.fromARGB(255, 255, 253, 253),
      //             ),
      //           ),
      //           const SizedBox(width: 10),
      //           Text(
      //             'Items: ${cartController.cartItemCount}',
      //             style: const TextStyle(
      //               fontSize: 16,
      //               height: 1,
      //               fontWeight: FontWeight.w500,
      //               color: Color.fromARGB(255, 255, 253, 253),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildCategoriesList() {
    final selectedCategoryId =
        selectedCategoryController.selectedCategoryId.obs;
    User user = User.fromJson(GetStorage().read('user') ?? {});
    final categoryIcons = {
      "04-Tequeños": Icons.abc_sharp,
      "03-Cachitos": Icons.access_alarm,
      "02-Pastelitos": Icons.add_home,
      "01-Empanadas": Icons.accessibility,
      "05-Mini Pan": Icons.account_box,
    };
    return FutureBuilder<List<Category>>(
      future: CategoryController.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator(
            radius: 20.0,
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error al obtener las categorías'),
          );
        } else {
          final categories = snapshot.data!;
          if (categories.isNotEmpty) {
            selectedCategoryController.setSelectedCategory(categories.first.id);
            con.getProductsByCategoryPreCocidos(
                categories.first.name, user.id!);
            con.getProductsByCategoryCrudos(categories.first.name, user.id!);
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final icon = categoryIcons[category.name];
                final isSelected =
                    selectedCategoryController.selectedCategoryId.value ==
                        category.id;

                return GestureDetector(
                  onTap: () async {
                    selectedCategoryController.setSelectedCategory(category.id);
                    con.getProductsByCategoryPreCocidos(
                        category.name, user.id!);
                    con.getProductsByCategoryCrudos(category.name, user.id!);
                  },
                  child: SizedBox(
                    width: 80,
                    height: 130,
                    child: Obx(() {
                      final isSelected =
                          selectedCategoryId.value == category.id;
                      return Column(
                        children: [
                          Card(
                            color: isSelected
                                ? const Color(0xE5FF5100)
                                : const Color.fromARGB(255, 223, 222, 222),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 223, 222, 222),
                              ),
                            ),
                            child: Container(
                              width: 80,
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                              child: CachedNetworkImage(
                                imageUrl: category.image ?? "",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) {
                                  return Container();
                                },
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  String _getBarcodeDescription(String barcode) {
    String secondSet = barcode.substring(2, 4);

    switch (secondSet) {
      case '01':
        return 'Grande';
      case '02':
        return 'Mediano';
      case '03':
        return 'Chico';
      default:
        return 'sin tamaño';
    }
  }

  void setState(Null Function() param0) {}
}

class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  String get searchFieldLabel => 'Search Products';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final ClientProfileInfoController con1 =
            Get.put(ClientProfileInfoController());
        final int? userId =
            con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
        return ListTile(
          title: Text(product.name),
          subtitle: Text(
            '\$${((product.tam1 ?? 1) * product.price!).toStringAsFixed(2)}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductoDetalleNPage(
                  product: product,
                  customerId: userId,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final ClientProfileInfoController con1 =
            Get.put(ClientProfileInfoController());
        final int? userId =
            con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                // offset: Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${((product.tam1 ?? 1) * product.price!).toStringAsFixed(2)}',
                    style: const TextStyle(
                      // color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Category: ${product.categoryId}',
                    style: const TextStyle(
                      // color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductoDetalleNPage(
                                product: product,
                                customerId: userId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xE5FF5100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Text(
                            'See Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelectedCategoryController extends GetxController {
  RxInt selectedCategoryId = RxInt(-1);

  void setSelectedCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
  }
}

Future<void> refreshCategories() async {
  try {
    final newCategories = await CategoryController.fetchCategories();
    categories.assignAll(newCategories);
  } catch (e) {
    print('Error al recargar las categorías: $e');
  }
}

class MyButtonsWidget extends StatefulWidget {
  final Map<int, String> selectedSizeMultipliers;
  final String tam1;
  final String tam2;
  final Function(String) onSizeSelected;

  MyButtonsWidget({
    required this.selectedSizeMultipliers,
    required this.tam1,
    required this.tam2,
    required this.onSizeSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyButtonsWidgetState createState() => _MyButtonsWidgetState();
}

class _MyButtonsWidgetState extends State<MyButtonsWidget> {
  late String selectedButton;

  @override
  void initState() {
    super.initState();
    selectedButton = ""; // Inicializa selectedButton según tus necesidades
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            _handleButtonPress(widget.tam1);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedButton == widget.tam1
                ? Colors.green
                : const Color(0xE5FF5100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            "x${widget.tam1}",
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        if (widget.tam1 != widget.tam2) ...[
          const SizedBox(width: 7),
          ElevatedButton(
            onPressed: () {
              _handleButtonPress(widget.tam2);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedButton == widget.tam2
                  ? Colors.green
                  : const Color(0xE5FF5100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(
              "x${widget.tam2}",
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _handleButtonPress(String button) {
    setState(() {
      if (selectedButton != button) {
        selectedButton = button;
        widget.selectedSizeMultipliers[1] = button;
        widget.onSizeSelected(
            button); // Llamar a la función de devolución de llamada
        print(selectedButton);
        Get.snackbar(
          'Done',
          'Box of $button units Selected',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
    });
  }
}
