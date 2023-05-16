import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/product_dto.dart';

class OrderDto {
const  OrderDto({
    this.id,
this.products,
    this.img,
    this.price,
    this.status,
    this.dateCreated,
  });
  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      id: json['_id'] as String,
      products: (json['products'] as List)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      img: json['img'] as String,
      price: json['price'] as int,
      status: json['status'] as bool,
      dateCreated: json['date_created'] as String,
    );
  }
final  String ? id;
final  List<ProductDto>? products;
final  String? img;
final  int? price;
final  bool? status;
final  String? dateCreated;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['_id'] = id;
    if (products != null) {
      map['products'] = products?.map((ProductDto v) => v.toJson()).toList();
    }
    map['img'] = img;
    map['price'] = price;
    map['status'] = status;
    map['date_created'] = dateCreated;
    return map;
  }
  static List<OrderDto> convertJson(List list) {
 final   List<OrderDto> data =
    list.map((json ) => OrderDto.fromJson(json as Map<String, dynamic>)).toList();
    return data;
  }
  @override
  String toString() {
    return 'OrderDto{id: $id, products: $products, img: $img, price: $price, status: $status, dateCreated: $dateCreated}';
  }
}