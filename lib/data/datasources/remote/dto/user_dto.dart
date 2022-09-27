class UserDto {
  UserDto({
    this.email,
    this.name,
    this.phone,
    this.userGroup,
    this.registerDate,
    this.token,
    this.address
  });

  UserDto.fromJson(dynamic json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    userGroup = json['userGroup'];
    registerDate = json['registerDate'];
    token = json['token'];
    address = json['address'];
  }

  String? email;
  String? name;
  String? phone;
  int? userGroup;
  String? registerDate;
  String? token;
  String? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
}
