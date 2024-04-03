import 'package:flutter/material.dart';
import 'package:hostel_management/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(rollNo: ' ',id: ' ', userName: ' ',firstName: ' ',lastName: ' ', email: ' ', password: ' ', address: ' ',phoneNumber:' ', type: ' ', block: ' ',roomNo: ' ');

  User get user => _user;

  void setUser(String user){
    _user = User.fromJson(user);
    notifyListeners();
  }
}