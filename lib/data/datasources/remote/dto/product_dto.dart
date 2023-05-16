class ProductDto {
const ProductDto({
      this.id, 
      this.name, 
      this.address, 
      this.price, 
      this.img, 
      this.quantity, 
      this.gallery
  });

  factory ProductDto.fromJson(Map<String,dynamic> json) {
    return ProductDto(
    id : json['_id'],
    name : json['name'],
    address : json['address'],
    price : json['price'],
    img : json['img'],
    quantity : json['quantity'],
    gallery : json['gallery'] != null ? json['gallery'].cast<String>() : [],
    );
  }

 final String? id;
   final String? name;
   final String? address;
   final num? price;
   final String? img;
   final num? quantity;
    final List<String>? gallery;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
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

  @override
  String toString() {
    return 'ProductDto{id: $id, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery}';
  }
}

