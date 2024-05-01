import 'dart:convert';

class User {
  final String rollNo;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String phoneNumber;
  final String type;
  final String block;
  final String roomNo;
  final String faceData1;
  final String faceData2;
  final String faceData3;
  //final List<dynamic> cart;

  User({
    required this.id,
    required this.rollNo,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.phoneNumber,
    required this.type,
    required this.block,
    required this.roomNo,
    required this.faceData1,
    required this.faceData2,
    required this.faceData3,
    //required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rollNo': rollNo,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
      'type': type,
      'block': block,
      'roomNo': roomNo,
      'faceData1': faceData1,
      'faceData2': faceData2,
      'faceData3': faceData3,
      //'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      rollNo: map['rollNo'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      type: map['type'] ?? '',
      block: map['block'] ?? '',
      roomNo: map['roomNo'] ?? '',
      faceData1: map['faceData1'] ?? '',
      faceData2: map['faceData2'] ?? '',
      faceData3: map['faceData3'] ?? '',
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
    String? rollNo,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? address,
    String? phoneNumber,
    String? type,
    String? block,
    String? roomNo,
    String? faceData1,
    String? faceData2,
    String? faceData3,
  }) {
    return User(
      id: id ?? this.id,
      rollNo: rollNo ?? this.rollNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      block: block ?? this.block,
      roomNo: roomNo ?? this.roomNo,
      faceData1: faceData1 ?? this.faceData1,
      faceData2: faceData2 ?? this.faceData2,
      faceData3: faceData2 ?? this.faceData3,
    );
  }
}
