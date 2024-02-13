import 'dart:convert';
import 'package:employe_management_system/Model/logoutModel.dart';
import 'package:flutter/foundation.dart';
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
          "Accept" : "application/json"
        },
        body: json.encode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        /// save token and expiry time
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        if (kDebugMode) {
          print("res: "+ response.statusCode.toString());
          print("res: "+ response.body.toString());
        }
        //throw Exception('Failed to authenticate');
        if(response.statusCode == 422){
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            'Check the input data format',
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

  Future<LogoutModel> logout(
      {required String token}) async {
    final url = Uri.parse(AppConstants.logOutUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Accept" : "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return LogoutModel.fromJson(jsonDecode(response.body));
      } else {
        if (kDebugMode) {
          print("res: "+ response.statusCode.toString());
          print("res: "+ response.body.toString());
        }
        //throw Exception('Failed to authenticate');
        if(response.statusCode == 422){
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            responseData[0].toString(),
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
        return LogoutModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to logout');
    }
  }
}