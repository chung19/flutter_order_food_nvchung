
import 'product_dto.dart';

class CartDto {
  CartDto({
    this.id,
    this.products,
    this.idUser,
    this.price
  });

  CartDto.fromJson(dynamic json) {
    id = json['_id'] as String;
    if (json['products'] != null) {
      products = [] ;
      json['products'].forEach((v) {
        products?.add(ProductDto.fromJson(v));
      });
    }
    idUser = json['id_user'] as String;
    price = json['price']  ;
  }

  String? id;
  List<ProductDto>? products;
  String? idUser;
  num? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['id_user'] = idUser;
    map['price'] = price;
    return map;
  }

  static CartDto convertJson(dynamic json) => CartDto.fromJson(json);
}
