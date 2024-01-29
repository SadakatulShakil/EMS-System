import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../Model/auth_session_model.dart';
import '../screen/login/widget/main_login_widget.dart';

class AuthSessionProvider with ChangeNotifier{

  bool? isLoggedIn;
  String userToken ='';
  bool? isDomainVerified;

  Future<void> saveDomainSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDomainVerified', true);
    isDomainVerified = true;
    notifyListeners();
  }

  Future<void> saveLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> verifyDomain(BuildContext context, String domain) async {
    // Simulate domain verification
    // Replace this with actual domain verification logic
    await Future.delayed(Duration(seconds: 1));

    if (["softwind", "enocis", "bkash"].contains(domain)) {
      // Valid domain
      saveDomainSession();

      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Domain Verify Successfully'),
        duration: Duration(seconds: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainLoginPage()),
      );
    } else {
      // Invalid domain
      isDomainVerified = false;
      notifyListeners();
    }
  }

  Future<bool> saveUser(AuthSessionModel user, int timeToExpire) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // Store the expiration time for the "token" key (24 hours from now)
    final currentTime = DateTime.now();
    final expirationTime = currentTime.add(Duration(hours: timeToExpire));
    await sp.setString("tokenExpirationTime", expirationTime.toIso8601String());

    sp.setString("token", user.authToken.toString());
    sp.setString("userAccountType", user.userAccountType.toString());

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
        return AuthSessionModel(authToken: "", userAccountType: "");
      } else {
        final String? token = sp.getString("token");

        final String? accountType = sp.getString("userAccountType");
        return AuthSessionModel(
            authToken: token.toString(),
            userAccountType: accountType.toString());
      }
    } else {
      return AuthSessionModel(authToken: '', userAccountType: '');
    }
  }

  Future<bool> remove() async {
    isLoggedIn = true;
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("token");
    sp.remove("userAccountType");
    sp.remove("tokenExpirationTime");
    notifyListeners();
    return true;
  }

}