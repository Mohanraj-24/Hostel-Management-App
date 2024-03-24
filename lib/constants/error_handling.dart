import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_management/constants/utils.dart';

void httpErrorHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}){
  switch(response.statusCode){
    case 200 :
      onSuccess();
      break;
    case 400 :
      showSnackBar(context, jsonDecode(response.body)['msg']);
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
    default: 
      showSnackBar(context, response.body);
  }
}