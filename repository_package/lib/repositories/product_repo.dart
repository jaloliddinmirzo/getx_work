import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:data_package/data_package.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs; // Observable ro'yxat
  var shoppingProduct = <ProductModel>[].obs; // Observable ro'yxat
  Box<ProductModel>? box;
  Box<ProductModel>? shoppingBox;

  @override
  void onInit() {
    super.onInit();
    initBox();
  }

  Future<void> initBox() async {
    box = await Hive.openBox<ProductModel>("productsBox");
    shoppingBox = await Hive.openBox<ProductModel>("shoppingBox");
    _loadProducts(); // Hive dan ma'lumotlarni yuklash
    _loadCart();
  }

  // Hive dan ma'lumotlarni o'qib, students ro'yxatini yangilash
  void _loadProducts() {
    if (box != null) {
      products.value = box!.values.toList();
    }
  }

  void _loadCart() {
    if (box != null) {
      shoppingProduct.value = shoppingBox!.values.toList();
    }
  }

  // Yangi student qo'shish
  Future<void> addStudent({
    required String title,
    required num price,
  }) async {
    if (box != null) {
      await box!.add(ProductModel(title: title, price: price));
      _loadProducts(); // students ro'yxatini yangilash
      update(); // UI ni yangilash
    }
  }

  Future<void> clearShoppingBox() async {
    if (shoppingBox != null) {
      await shoppingBox!.clear();
      _loadCart(); // Ro'yxatni yangilash
      update(); // UI ni yangilash
    }
  }

  Future<void> addShoppingProduct({required int index}) async {
    if (box != null) {
      var productToAdd = products[index];
      await shoppingBox!.add(productToAdd);
      _loadCart();
      update();
    }
  }

  Future<void> removeShoppingProduct({required int index}) async {
    if (shoppingBox != null) {
      await shoppingBox!.deleteAt(index);
      _loadCart();
      update();
    }
  }

  //  Update product
  Future<void> updateProduct({
    required ProductModel product,
    required String newTitle,
    required num newPrice,
  }) async {
    if (box != null) {
      var index = products.indexOf(product);
      if (index != -1) {
        var updatedProduct = ProductModel(
          title: newTitle,
          price: newPrice,
        );
        await box!.put(index, updatedProduct);
        _loadProducts();
        _loadCart();
        update();
      }
    }
  }

  Future<void> removeProduct({required ProductModel product}) async {
    if (box != null) {
      var index = products.indexOf(product);
      if (index != -1) {
        await box!.deleteAt(index);
        _loadProducts();
        _loadCart();
        update();
      }
    }
  }

  Map<ProductModel, int> get groupedShoppingProducts {
    Map<ProductModel, int> groupedProducts = {};
    for (var product in shoppingProduct) {
      if (groupedProducts.containsKey(product)) {
        groupedProducts[product] = groupedProducts[product]! + 1;
      } else {
        groupedProducts[product] = 1;
      }
    }
    return groupedProducts;
  }

  num get totalPrice {
    num total = 0;
    for (var product in shoppingProduct) {
      total += product.price;
    }
    return total;
  }

  // students ro'yxatini olish
  List<ProductModel> get getStudents => products;
  // List<ProductModel> get getShopingProducts => shoppingProduct;
}
