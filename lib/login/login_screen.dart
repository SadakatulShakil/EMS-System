import 'package:employe_management_system/home/dashboard_screen.dart';
import 'package:employe_management_system/login/widget/text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utill/color_resources.dart';
import '../home/home_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/welcome.jpg"), fit: BoxFit.cover,),
              ),
            ),
            Center(
              child: Container(
                width: 300,
                height: 400,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 80,width: 80,),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hey, Welcome!',
                        style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Text(
                      'Continue with company email',
                      style: TextStyle(
                          fontSize: 16 / MediaQuery.textScaleFactorOf(context), color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    GetTextFormField(
                      //onChangeText: dataProvider.updateTextFieldUsersEmail,
                      controller: emailController,
                      hintName: "e.g username@company.com",
                      lebelName: "Email Address",
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async{
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()),
                                  (route) => false);
                          // Implement sign-in logic here
                          // if(emailController.text == '' && passwordController.text == ''){
                          //   // Obtain shared preferences.
                          //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                          //   await prefs.setString('isLogged', 'logged');
                          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()),
                          //           (route) => false);
                          // }else{
                          //   Get.snackbar(
                          //     'Warning',
                          //     'User id or Password is incorrect !',
                          //     snackPosition: SnackPosition.TOP,
                          //     backgroundColor: Colors.redAccent,
                          //     colorText: Colors.white,
                          //     borderRadius: 10,
                          //     margin: EdgeInsets.all(10),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(

                          primary: accent, // Set the background color here
                        ),
                        child: Text('Continue ', style: TextStyle(color: Colors.white, fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

