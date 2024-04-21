import 'dart:convert';
import 'package:employe_management_system/Model/logoutModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/auth_model.dart';
import '../Model/email_sending_model.dart';
import '../Model/otp_verify_model.dart';
import '../Model/reset_password_model.dart';
import '../screen/login/widget/verify_otp_page.dart';
import '../utill/app_constant.dart';
import 'package:get/get.dart';

class AuthProvider extends ChangeNotifier {

  bool _loadingIndicator = false;
  bool get isLoadingProfile => _loadingIndicator;
  void updateDataLoadingIndicator(bool value) {
    _loadingIndicator = value;
    notifyListeners();
  }

  ResetPasswordModel? _resetInfo;
  ResetPasswordModel? get resetInfo => _resetInfo;

  void setResetInfoData(ResetPasswordModel data){
    _resetInfo = data;
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
      } else if(response.statusCode == 422){
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }else if(response.statusCode == 500){
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );

        return AuthModel.fromJson(jsonDecode(response.body));
      }
      return AuthModel.fromJson(jsonDecode(response.body));
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
      } else if(response.statusCode == 422){
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }else if (response.statusCode == 422) {
        Get.snackbar(
          'Warning',
          jsonDecode(response.body.toString())["message"],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        notifyListeners();
      }else if(response.statusCode == 500){
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }
        return LogoutModel.fromJson(jsonDecode(response.body));

    } catch (e) {
      throw Exception('Failed to logout');
    }
  }
  Future<MailSendModel> sendOtp(String email, BuildContext context) async {
    updateDataLoadingIndicator(true);
    final url = Uri.parse(AppConstants.sendOtp);
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': email,
          })
      );

      if (response.statusCode == 200) {
        updateDataLoadingIndicator(false);
        print("res: " + response.body.toString());
        Get.snackbar(
          'Success',
          jsonDecode(response.body.toString())["message"],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        notifyListeners();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(email),
          ),
        );
        return MailSendModel.fromJson(jsonDecode(response.body));// Update user data
      }else if (response.statusCode == 422) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        } else if (response.statusCode == 500) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }else if (response.statusCode == 400) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }
        return MailSendModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      updateDataLoadingIndicator(false);
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<OtpVerifyModel> verifyOtp(String otp, String password) async {
    updateDataLoadingIndicator(true);
    final url = Uri.parse(AppConstants.verifyOtp);
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'otp_code': otp,
            'password': password
          })
      );

      if (response.statusCode == 200) {
        updateDataLoadingIndicator(false);
        print("res: " + response.body.toString());
        Get.snackbar(
          'Success',
          jsonDecode(response.body.toString())["message"],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        notifyListeners();
        return OtpVerifyModel.fromJson(jsonDecode(response.body));// Update user data
      } else if (response.statusCode == 422) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        } else if (response.statusCode == 500) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }else if (response.statusCode == 400) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        return OtpVerifyModel.fromJson(jsonDecode(response.body));
      }
      return OtpVerifyModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      updateDataLoadingIndicator(false);
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<ResetPasswordModel> resetPassword(String token, String old_password, password, confirmPassword) async {
    updateDataLoadingIndicator(true);
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.updatePassword);
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'old_password': old_password,
            'password': password,
            'password_confirmation': confirmPassword
          })
      );

      if (response.statusCode == 200) {
        updateDataLoadingIndicator(false);
        print("res: " + response.body.toString());
        final resetData = ResetPasswordModel.fromJson(jsonDecode(response.body));
        setResetInfoData(resetData);
        Get.snackbar(
          'Success',
          resetData.message.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        notifyListeners();
        return ResetPasswordModel.fromJson(jsonDecode(response.body));// Update user data
      } else if (response.statusCode == 422) {
          updateDataLoadingIndicator(false);
          final resetData = ResetPasswordModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            resetData.message.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        } else if (response.statusCode == 500) {
          updateDataLoadingIndicator(false);
          Get.snackbar(
            'Warning',
            'Internal server issue !',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();

        return ResetPasswordModel.fromJson(jsonDecode(response.body));
      }
      return ResetPasswordModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      updateDataLoadingIndicator(false);
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

}