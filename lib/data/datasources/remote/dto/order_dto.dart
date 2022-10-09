
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/product_dto.dart';
class OrderDto {
  OrderDto({
    String? id,
    List<ProductDto>? products,
    String? img ,
    int? price,
    bool? status,
    String? date_created,
  }) {
    _id = id;
    _products = products;
    _img= img;
    _price = price;
    _status = status;
    _date_created = date_created;
  }

  OrderDto.fromJson(dynamic json) {
    _id = json['_id'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(ProductDto.fromJson(v));
      });
    } else {
      _products = [];
    }

    _img = json['img'];
    _price = json['price'];

    _status = json['status'];
    _date_created = json['date_created'];
  }

  String? _id;
  List<ProductDto>? _products;
  String?  _img;
  int? _price;
  bool? _status;
  String? _date_created;

  String? get id => _id;

  List<ProductDto>? get products => _products;

  String?  get img => _img;
  int? get price => _price;

  bool? get status => _status;

  String? get date_created => _date_created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    map['img'] = _img;
    map['price'] = _price;
    map['status'] = _status;
    map['date_created'] = _date_created;
    return map;
  }


  static List<OrderDto> convertJson(List list) {
    List<OrderDto> data = list.map((json) => OrderDto.fromJson(json)).toList();
    return data;
  }
}


