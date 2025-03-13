import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository_package/repository_package.dart';
import 'package:data_package/data_package.dart';


class HomeView extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  static String path = "/shopping";

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fruts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Get.toNamed(HomeView.path);
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (productController.getStudents.isEmpty) {
          return Center(
            child: Text(
              "Hozircha ma'lumot yo'q",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: productController.getStudents.length,
          itemBuilder: (context, index) {
            var products = productController.getStudents[index];
            return GestureDetector(
              onLongPress: () {
                productController.removeProduct(product: products);
                if (Get.isSnackbarOpen) {
                  Get.closeAllSnackbars();
                }
                Get.snackbar(
                  "O'chirildi",
                  "${products.title} Frutsdan olib tashlandi",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    products.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Narxi: ${products.price} so'm",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditDialog(products);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart,
                            color: Colors.deepPurple),
                        onPressed: () {
                          productController.addShoppingProduct(index: index);
                          if (Get.isSnackbarOpen) {
                            Get.closeAllSnackbars();
                          }
                          Get.snackbar(
                            "Savatga qo'shildi",
                            "${products.title} savatga qo'shildi",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.deepPurple,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Yangi mahsulot qo'shish dialogi
  void _showAddDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    Get.defaultDialog(
      title: "Yangi mahsulot qo'shish",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Mahsulot nomi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Narxi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (titleController.text.isNotEmpty &&
              priceController.text.isNotEmpty) {
            productController.addStudent(
              title: titleController.text,
              price: num.parse(priceController.text),
            );
            Get.back();
            Get.snackbar(
              "Muvaffaqiyatli",
              "Mahsulot qo'shildi",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.deepPurple,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Xatolik",
              "Iltimos, barcha maydonlarni to'ldiring",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text("Qo'shish", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Bekor qilish", style: TextStyle(color: Colors.deepPurple)),
      ),
    );
  }

  // Mahsulotni tahrirlash dialogi
  void _showEditDialog(ProductModel product) {
    final TextEditingController titleController =
        TextEditingController(text: product.title);
    final TextEditingController priceController =
        TextEditingController(text: product.price.toString());

    Get.defaultDialog(
      title: "Mahsulotni tahrirlash",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Mahsulot nomi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Narxi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (titleController.text.isNotEmpty &&
              priceController.text.isNotEmpty) {
            productController.updateProduct(
              product: product,
              newTitle: titleController.text,
              newPrice: num.parse(priceController.text),
            );
            Get.back();
            Get.snackbar(
              "Muvaffaqiyatli",
              "Mahsulot yangilandi",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.deepPurple,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Xatolik",
              "Iltimos, barcha maydonlarni to'ldiring",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text("Yangilash", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Bekor qilish", style: TextStyle(color: Colors.deepPurple)),
      ),
    );
  }
}
