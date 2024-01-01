import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _doSessionTask ()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? session = prefs.getString('isLogged');
    Timer(Duration(seconds: 3), () {
      if(session != 'logged'){
        Navigator.pushReplacementNamed(context, '/auth');
      }else{
        Navigator.pushReplacementNamed(context, '/home');
      }

    });
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
