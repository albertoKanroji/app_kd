import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:kd_latin_food/firebase_options.dart';
import 'package:kd_latin_food/src/models/category.dart';
import 'package:kd_latin_food/src/models/user.dart';
import 'package:kd_latin_food/src/pages/admin/botonbar.dart';
import 'package:kd_latin_food/src/pages/admin/envios_admin.dart';
import 'package:kd_latin_food/src/pages/admin/pedidos_admin.dart';
import 'package:kd_latin_food/src/pages/client/delivery/list/client_delivery_page.dart';
import 'package:kd_latin_food/src/pages/client/products/list/client_products_list_page.dart';
import 'package:kd_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:kd_latin_food/src/pages/envios/envios_page.dart';
//import 'package:kd_latin_food/src/pages/home/home_page.dart';
import 'package:kd_latin_food/src/pages/login/login_page.dart';
import 'package:kd_latin_food/src/pages/login/login_page_admin.dart';
import 'package:kd_latin_food/src/pages/register/register_page.dart';
import 'package:kd_latin_food/src/providers/category_provider.dart';
import 'package:kd_latin_food/src/splash/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

CategoriesProviders categoriesProviders = CategoriesProviders();
User userSession = User.fromJson(GetStorage().read('user') ?? {});
final ClientProfileInfoController con1 = Get.put(ClientProfileInfoController());
void main() async {
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  //Get.put(CartController());
}

List<Category> categories = <Category>[].obs;
void getCategories() async {
  var categoriesProviders2 = categoriesProviders;
  // ignore: unused_local_variable
  var result = await categoriesProviders2.getAll();
  // Imprimir el contenido de result por consola
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;
  @override
  void initState() {
    //  getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = User.fromJson(GetStorage().read('user') ?? {});
    final int? userId = user.id;
    // Obtener la hora actual
    final DateTime now = DateTime.now();
    // Determinar si es de día o de noche
    final bool isDayTime = now.hour >= 22 || now.hour < 18;

    // Determina el tema inicial basado en la hor a del día
    final AdaptiveThemeMode initialTheme = isDayTime
        ? AdaptiveThemeMode.light
        : AdaptiveThemeMode.dark;
    return AdaptiveTheme(
        light: ThemeData.light().copyWith(
          primaryColor: const Color(0xE5FF5100),
          // fontFamily: 'Poppoins',
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 255, 255, 255),
            onPrimary: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          brightness: Brightness.light,
        ),
        dark: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors
                .black, // Color del AppBar (equivalente al backgroundColor)
            foregroundColor: Colors
                .white, // Color de primer plano del AppBar (afecta al color del texto e iconos)
            elevation: 0, // Sin sombra debajo del AppBar
            centerTitle: true, // Centra el título del AppBar
            iconTheme: IconThemeData(
                color: Colors
                    .white), // Tema de iconos (afecta al color de los iconos)
            titleTextStyle: TextStyle(
              color: Colors.white, // Color del texto del título del AppBar
              fontSize: 20, // Tamaño del texto del título del AppBar
              fontWeight:
                  FontWeight.bold, // Peso de la fuente del título del AppBar
            ),
          ),
          primaryColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            onPrimary:
                Colors.white, // Color del texto cuando se usa el color primario
            background: Colors.black, // Color de fondo principal
            onBackground: Colors
                .white, // Color del texto cuando se usa el color de fondo principal
            surface: Colors.black, // Color de la superficie (como cards)
            onSurface: Colors
                .white, // Color del texto cuando se usa el color de la superficie
          ),
          brightness: Brightness.dark,
        ),
        initial: initialTheme,
        builder: (theme, darkTheme) => GetMaterialApp(
              title: 'LatinFood',
              theme: theme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const SecondClass()),
                GetPage(name: '/login', page: () => LoginPage()),
                GetPage(name: '/loginAdmin', page: () => LoginPageAdmin()),
                GetPage(name: '/register', page: () => const RegisterPage()),
                // ignore: prefer_const_constructors
                GetPage(name: '/PedidosAdmin', page: () => PedidosAdmin()),
                GetPage(
                    name: '/SalesListPage', page: () => const SalesListPage()),
                //GetPage(name: '/home', page: () =>  HomePage()),
                GetPage(
                    name: '/homeadmin',
                    page: () => ClientProductsListPageAdmin()),
                GetPage(name: '/home', page: () => ClientProductsListPage()),
                // GetPage(name: '/home/info', page: () =>  ClientProfileInfoPage()),
                GetPage(
                    name: '/home/delyvery',
                    page: () => ClientOrdersPage(customerId: userId!)),
                GetPage(
                    name: '/home/profile/address',
                    page: () => const ClientDeliveryListPage()),
              ],
              navigatorKey: Get.key,
            ));
  }
}
