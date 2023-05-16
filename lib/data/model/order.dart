
import 'package:flutter_order_food_nvchung/data/model/product.dart';

class Order {

  Order([String? id, List<Product>? products,String? img, int? price, bool? status, String? date_created]) {
    this.id = id ??= '';
    this.products = products ??= [];
    this.img=img??'';
    this.price = price ??= 0;
    this.status = status ??= false;
    this.date_created = date_created ??= '';
  }
  late String? id;
  late List<Product>? products;
  late String? img;
  late int? price;
  late bool? status;

  @override
  String toString() {
    return 'Order{id: $id, products: $products, img: $img, price: $price, status: $status, date_created: $date_created}';
  }

  late String? date_created;
}


