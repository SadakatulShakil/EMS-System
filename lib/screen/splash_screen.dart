import 'package:employe_management_system/providers/auth_session_provider.dart';
import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'home/dashboard_screen.dart';
import 'login/login_screen.dart';
import 'login/widget/main_login_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _doSessionTask ()async {
    final sessionProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isDomainVerified = prefs.getBool('isDomainVerified') ?? false;
    sessionProvider.getUser().then((value) async{
      if(isDomainVerified){
        if (value.authToken == '' || value.authToken == 'null') {
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLoginPage()),
          );
        }else{
          sessionProvider.userToken = value.authToken;
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
    });

    // Timer(Duration(seconds: 3), () {
    //   if (isDomainVerified) {
    //     // Domain is verified
    //     if (isLoggedIn) {
    //       // User is logged in
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => DashBoardScreen()),
    //       );
    //     } else {
    //       // User is not logged in, go to login page
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => MainLoginPage()),
    //       );
    //     }
    //   } else {
    //     // Domain is not verified, go to domain page
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //     );
    //   }
    //
    // });
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
