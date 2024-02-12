import 'dart:convert';

import 'package:employe_management_system/Model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../Model/auth_session_model.dart';
import '../screen/login/widget/main_login_widget.dart';

class AuthSessionProvider with ChangeNotifier{

  bool? isLoggedIn;
  bool isLoggedOut = false;
  String userToken ='';
  bool? isDomainVerified;
  AuthModel? _userData;

  AuthModel? get authData => _userData;

  void setAuthData(AuthModel data) async{
    _userData = data;
    notifyListeners();
  }

  Future<void> saveLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> saveUser(AuthSessionModel user, int timeToExpire) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // Store the expiration time for the "token" key (24 hours from now)
    final currentTime = DateTime.now();
    final expirationTime = currentTime.add(Duration(hours: timeToExpire));
    await sp.setString("tokenExpirationTime", expirationTime.toIso8601String());


    sp.setString("token", user.authToken.toString());

    // Store the serialized user object in SharedPreferences
    notifyListeners();
    return true;
  }

  Future<AuthSessionModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final String? tokenExpirationTime = sp.getString("tokenExpirationTime");
    if (tokenExpirationTime != null) {
      final expirationTime = DateTime.parse(tokenExpirationTime);
      final currentTime = DateTime.now();
      if (currentTime.isAfter(expirationTime)) {
        await remove();
        return AuthSessionModel(authToken: "");
      } else {
        final String? token = sp.getString("token");

        final String? accountType = sp.getString("userAccountType");
        return AuthSessionModel(
            authToken: token.toString());
      }
    } else {
      return AuthSessionModel(authToken: '');
    }
  }

  Future<bool> remove() async {
    isLoggedOut = true;
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("token");
    sp.remove("userAccountType");
    sp.remove("tokenExpirationTime");
    notifyListeners();
    return true;
  }

}