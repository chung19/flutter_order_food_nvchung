
import 'package:flutter_order_food_nvchung/data/model/product.dart';

 class Cart {

  Cart([String? id, List<Product>? products,num? price, String? idUser, ]) {
    this.id = id ?? '';
    this.products = products ?? [];
    this.idUser = idUser ?? '';
    this.price = price ?? 0;
  }
  late  final String id;
  late final List<Product> products;
  late  final String idUser;
  late  final num price;

  @override
  String toString() {
    return 'Cart{id: $id, products: $products, idUser: $idUser, price: $price}';
  }
}
