import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/product_dto.dart';

class CartDto {
  const CartDto({
    this.id,
    this.products,
    this.idUser,
    this.price,
  });

  factory CartDto.fromJson(Map<String, dynamic> json) {
    return CartDto(
      id: json['_id'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e))
          .toList                       (),
      idUser: json['id_user'] as String,
      price: json['price'] as num,
    );
  }

  final String? id;
  final List<ProductDto>? products;
  final String? idUser;
  final num? price;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['_id'] = id;
    if (products != null) {
      map['products'] = products?.map((ProductDto e) => e.toJson()).toList();
    }
    map['id_user'] = idUser;
    map['price'] = price;
    return map;
  }

  static CartDto fromJsonFactory(dynamic json) =>
      CartDto.fromJson(json as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartDto{id: $id, products: $products, idUser: $idUser, price: $price}';
  }
}
