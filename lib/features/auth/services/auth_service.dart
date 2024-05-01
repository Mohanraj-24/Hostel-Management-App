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
// import 'dart:typed_data';

class AuthService {
  void signUp({
    required String rollNo,
    required String email,
    required String password,
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String block,
    required String roomNo,
    required String faceData1,
    required String faceData2,
    required String faceData3,
  }) async {
    try {
      User user = User(
        id: '',
        rollNo: rollNo,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        block: block,
        roomNo: roomNo,
        address: ' ',
        type: ' ',
        faceData1: faceData1,
        faceData2: faceData2,
        faceData3: faceData3,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required String rollNo,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'rollNo': rollNo, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print("Log in Res: ${res.body}");
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          print("Token in signin ${jsonDecode(res.body)['token']}");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addAttendance(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      print("Token in addAttendance $token");
      http.Response res = await http.post(
        Uri.parse('$uri/api/addAttendance'),
        headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"dateTime": DateTime.now().toIso8601String()}),
      );

      if (res.statusCode == 200) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));

        // Attendance added successfully
        print("Attendance added successfully");
      } else {
        // Handle error
        print("Failed to add attendance: ${res.body}");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      // print("Token in getUserData $token");
      try {
        http.Response res = await http
            .get(Uri.parse('$uri/api/getUserData'), headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json',
        });
        Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isUserLoggedIn(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      print("Token in isUserLoggedIn $token");
      try {
        http.Response res = await http
            .get(Uri.parse('$uri/api/getUserData'), headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json',
        });
        print(res.body);
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        if (responseData['message'] == "Unauthorized") return false;
        Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      } catch (e) {
        print(e);
        return false;
      }
      return token != null && token.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token'); // Remove token
      Provider.of<UserProvider>(context, listen: false)
          .clearUser(); // Clear user data from provider
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen())); // Navigate to login screen
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
