// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hostel_management/features/auth/screens/login_screen.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_management/constants/utils.dart';
import 'package:hostel_management/common/constants.dart';
import 'package:hostel_management/constants/error_handling.dart';
import 'package:hostel_management/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel_management/providers/user_provider.dart';


class AuthService{  
  void signUp({
    required String rollNo,
    required String email,
    required String password,
    required BuildContext context,
    required String userName,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String block,
    required String roomNo,
  }) async {
    try{
      User user = User(
        id: '', 
        rollNo: rollNo,
        userName: userName, 
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email, 
        password: password, 
        block : block,
        roomNo : roomNo,
        address: ' ', 
        type: ' ', 
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'), 
          body :user.toJson(),
          headers: <String,String> {
            'Content-Type' : 'application/json; charset=UTF-8',
          },
        );
      
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const LoginScreen())
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  void signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async{
    try{
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'), 
          body : jsonEncode({
            'email' : email,
            'password' : password
          }),
          headers: <String,String> {
            'Content-Type' : 'application/json; charset=UTF-8',
          },
        );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const HomeScreen())
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}