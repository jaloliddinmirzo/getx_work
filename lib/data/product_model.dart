import 'package:hive_flutter/adapters.dart';
part 'erp_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  num price;

  ProductModel({
    required this.title,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          price == other.price;

  @override
  int get hashCode => title.hashCode ^ price.hashCode;
}
