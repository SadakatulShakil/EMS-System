import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/auth_model.dart';
import '../utill/app_constant.dart';
import 'package:get/get.dart';

class AuthProvider extends ChangeNotifier {

  bool _loadingIndicator = false;
  bool get isLoadingProfile => _loadingIndicator;
  void updateDataLoadingIndicator(bool value) {
    _loadingIndicator = value;
    notifyListeners();
  }

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
        //throw Exception('Failed to authenticate');
        if(response.statusCode == 401){
          Get.snackbar(
            'Warning',
            'User id or Password is incorrect !',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }else if(response.statusCode == 500){
          Get.snackbar(
            'Warning',
            'Internal server issue !',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }
        return AuthModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to authenticate');
    }
  }
}