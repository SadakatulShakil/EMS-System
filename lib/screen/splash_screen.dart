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

   String expiryTime = prefs.getString('session_expiry')??'';
   print('cccccccccc: '+ expiryTime);
    if(expiryTime != ''){
      final expirationTime = DateTime.parse(expiryTime);
      final currentTime = DateTime.now();
      if(currentTime.isAfter(expirationTime)){
        prefs.setString('tokenId', '');
        prefs.setString('session_expiry', '');
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
        );
      }
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    // sessionProvider.getUser().then((value) async{
    //   if (value.authToken == '' || value.authToken == 'null') {
    //     await Future.delayed(const Duration(seconds: 3));
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //     );
    //   }else{
    //     sessionProvider.userToken = value.authToken;
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => DashBoardScreen()),
    //     );
    //   }
    // });

  }
  @override
  void initState() {
    super.initState();
    _doSessionTask();
    // Future.delayed(const Duration(seconds: 3)).then((value) => Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    // ));
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
