import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hostel_management/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    rollNo: ' ',
    id: ' ',
    firstName: ' ',
    lastName: ' ',
    email: ' ',
    password: ' ',
    address: ' ',
    phoneNumber: ' ',
    type: ' ',
    block: ' ',
    roomNo: ' ',
    faceData1: ' ',
    faceData2: ' ',
    faceData3: ' ',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void clearUser() {
    _user = User(
      rollNo: ' ',
      id: ' ',
      firstName: ' ',
      lastName: ' ',
      email: ' ',
      password: ' ',
      address: ' ',
      phoneNumber: ' ',
      type: ' ',
      block: ' ',
      roomNo: ' ',
      faceData1: ' ',
      faceData2: ' ',
      faceData3: ' ',
    );
    notifyListeners();
  }
}
