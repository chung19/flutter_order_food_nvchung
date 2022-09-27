class Product {
  late String id;
  late String name;
  late String address;
  late num price;
  late String img;
  late num quantity;
  late List<String> gallery;

  Product([String? id, String? name, String? address, num? price, String? img, num? quantity, List<String>? gallery]){
    this.id = id ?? "";
    this.name = name ?? "";
    this.address = address ?? "";
    this.price = price ?? -1;
    this.img = img ?? "";
    this.quantity = quantity ?? -1;
    this.gallery = gallery ?? [];
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery}';
  }
}