
import 'package:flutter_order_food_nvchung/data/model/product.dart';

class Cart {
  late String id;
  late List<Product> products;
  late String idUser;
  late num price;

  Cart([String? id, List<Product>? products,num? price, String? idUser, ]) {
    this.id = id ?? "";
    this.products = products ?? [];
    this.idUser = idUser ?? "";
    this.price = price ?? 0;
  }
}