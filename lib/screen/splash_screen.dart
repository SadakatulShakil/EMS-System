import 'dart:async';

import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/dashboard_screen.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _doSessionTask ()async {
    //final sessionProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool isDomainVerified = prefs.getBool('isDomainVerified') ?? false;

    String token = prefs.getString('tokenId')??'';
    print('cccccccccc: '+ token);
    if(token != ''){
      ///Session code hide as requirement
      // final expirationTime = DateTime.parse(expiryTime);
      // final currentTime = DateTime.now();
      // if(currentTime.isAfter(expirationTime)){
      //   prefs.setString('tokenId', '');
      //   prefs.setString('session_expiry', '');
      //   await Future.delayed(const Duration(seconds: 2));
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => LoginScreen()),
      //   );
      // }else
      {
        await Future.delayed(const Duration(microseconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
        );
      }
    }else{
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }

  }
  @override
  void initState() {
    super.initState();
    _doSessionTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150,width: 150,),
            SizedBox(height: 20,),
            Image.asset('assets/images/logo_text.png', height: 150,width: 200,),
          ],
        ),
      ),
    );

  }


}
