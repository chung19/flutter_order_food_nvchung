class UserDto {
  const UserDto({
    this.email,
    this.name,
    this.phone,
    this.userGroup,
    this.registerDate,
    this.token,
    this.address,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      userGroup: json['userGroup'],
      registerDate: json['registerDate'],
      token: json['token'],
      address: json['address'],
    );
  }

  final String? email;
  final String? name;
  final String? phone;
  final int? userGroup;
  final String? registerDate;
  final String? token;
  final String? address;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['email'] = email;
    map['name'] = name;
    map['phone'] = phone;
    map['userGroup'] = userGroup;
    map['registerDate'] = registerDate;
    map['token'] = token;
    map['address'] = address;
    return map;
  }

  static UserDto convertJson(dynamic json) => UserDto.fromJson(json);

  @override
  String toString() {
    return 'UserDto{email: $email, name: $name, phone: $phone, userGroup: $userGroup, registerDate: $registerDate, token: $token, address: $address}';
  }
}
