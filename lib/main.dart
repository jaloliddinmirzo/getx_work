import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_work/data/product_model.dart';
import 'package:getx_work/screens/home_screen.dart';
import 'package:getx_work/screens/shopping_screen.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ErpmodelAdapter());
  await Hive.openBox<ProductModel>("productsBox");
  await Hive.openBox<ProductModel>("shoppingBox");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => HomeView(),
        ),
        GetPage(
          name: "/shopping",
          page: () => ShoppingScreen(),
        ),

        // GetPage(name: ProductsScreen.path, page: () => ProductsScreen(),),
      ],
      title: 'XDA TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomeView(),
    );
  }
}
