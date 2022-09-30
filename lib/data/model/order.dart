
import 'package:flutter_order_food_nvchung/data/model/product.dart';

class Order {
  late String? id;
  late List<Product>? products;
  late int? price;
  late bool? status;
  late String? date_created;

  Order([String? id, List<Product>? products, int? price, bool? status, String? date_created]) {
    this.id = id ??= "";
    this.price = price ??= 0;
    this.products = products ??= [];
    this.status = status ??= false;
    this.date_created = date_created ??= "";
  }
}
