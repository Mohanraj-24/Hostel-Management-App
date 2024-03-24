import 'dart:convert';

class User {
  final String id;
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String phoneNumber;
  final String type;
  final String block;
  final String roomNo;
  //final List<dynamic> cart;

  User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.phoneNumber,
    required this.type,
    required this.block,
    required this.roomNo,
    //required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber':phoneNumber,
      'type': type,
      'block' : block,
      'roomNo' : roomNo,
      //'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      userName: map['userName'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      type: map['type'] ?? '',
      block : map['block'] ?? '',
      roomNo : map['block'] ?? '',
      // cart: List<Map<String, dynamic>>.from(
      //   map['cart']?.map(
      //     (x) => Map<String, dynamic>.from(x),
      //   ),
      // ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? userName,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? address,
    String? phoneNumber,
    String? type,
    String? block,
    String? roomNo,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      block : block ?? this.block,
      roomNo : roomNo ?? this.roomNo,
    );
  }
}