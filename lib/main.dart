import 'package:employe_management_system/home/dashboard_screen.dart';
import 'package:employe_management_system/splash_screen.dart';
import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/home_screen.dart';
import 'login/login_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/auth': (context) => LoginScreen(),
        '/home': (context) => DashBoardScreen(),
      },
    );
  }
}
