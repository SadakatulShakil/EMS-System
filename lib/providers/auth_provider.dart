import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/auth_model.dart';
import '../utill/app_constant.dart';

class AuthProvider extends ChangeNotifier {

  Future<AuthModel> authenticate(
      {required String username, required String password}) async {
    final url = Uri.parse(AppConstants.loginUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        print("res: "+ response.statusCode.toString());
        throw Exception('Failed to authenticate');
      }
    } catch (e) {
      throw Exception('Failed to authenticate');
    }
  }
}