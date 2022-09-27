class ProductDto {
  ProductDto({
      this.id, 
      this.name, 
      this.address, 
      this.price, 
      this.img, 
      this.quantity, 
      this.gallery
  });

  ProductDto.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'] != null ? json['gallery'].cast<String>() : [];
  }

  String? id;
  String? name;
  String? address;
  num? price;
  String? img;
  num? quantity;
  List<String>? gallery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['price'] = price;
    map['img'] = img;
    map['quantity'] = quantity;
    map['gallery'] = gallery;
    return map;
  }

  static List<ProductDto> convertJson(dynamic json) {
    return (json as List).map((e) => ProductDto.fromJson(e)).toList();
  }
}

// List myMap(List<dynamic> list, Function function) {
//   List<dynamic> newList = [];
//   for (int i = 0; i < list.length ; i++) {
//     newList.add(function(list[i]));
//   }
//   return newList;
// }