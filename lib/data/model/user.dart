class User {
  late String email;
  late String name;
  late String phone;
  late String registerDate;
  late String token;
  late String address;

  User([String? email, String? name, String? phone, String? registerDate, String? token, String? address]) {
    this.email = email ?? "";
    this.name = name ?? "";
    this.phone = phone ?? "";
    this.registerDate = registerDate ?? "";
    this.token = token ?? "";
    this.address = address ?? "";
  }

  @override
  String toString() {
    return 'User{email: $email, name: $name, phone: $phone, registerDate: $registerDate, token: $token, address: $address}';
  }
}