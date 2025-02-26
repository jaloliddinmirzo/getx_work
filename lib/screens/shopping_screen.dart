import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_work/controllers/product_controller.dart';

class ShoppingScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // AppBar rangini moslashtirish
      ),
      body: Obx(() {
        var groupedProducts = productController.groupedShoppingProducts;
        log(groupedProducts.length.toString());
        if (groupedProducts.isEmpty) {
          return Center(
            child: Text(
              "Hozircha ma'lumot yo'q",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: groupedProducts.length,
                itemBuilder: (context, index) {
                  var product = groupedProducts.keys.elementAt(index);
                  var quantity = groupedProducts[product];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Narxi: ${product.price} so'm",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              productController.removeShoppingProduct(
                                  index: index);
                              Get.snackbar(
                                "O'chirildi",
                                "${product.title} savatdan olib tashlandi",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.deepPurple,
                                colorText: Colors.white,
                              );
                            },
                            icon: Icon(Icons.remove, color: Colors.deepPurple),
                          ),
                          Text(
                            "Soni: $quantity",
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              productController.addShoppingProduct(
                                  index: productController.products
                                      .indexOf(product));
                              Get.snackbar(
                                "Qo'shildi",
                                "${product.title} savatga qo'shildi",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.deepPurple,
                                colorText: Colors.white,
                              );
                            },
                            icon: Icon(Icons.add, color: Colors.deepPurple),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Umumiy narxni ko'rsatish
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple, // Rangni moslashtirish
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Umumiy narx:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() {
                    return Text(
                      "${productController.totalPrice} so'm",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
