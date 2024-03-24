// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_management/constants/utils.dart';
import 'package:hostel_management/common/constants.dart';
import 'package:hostel_management/constants/error_handling.dart';
import 'package:hostel_management/models/user.dart';

class AuthService{  
  void signUp({
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
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}