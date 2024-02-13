import 'package:employe_management_system/screen/login/widget/text_from_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../utill/color_resources.dart';
import '../home/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final permission = Permission.location;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
        // Permission is granted
      } else if (result.isDenied) {
        // Permission is denied
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied
      }
    }
  }

  Future<void> _authenticate(String username, String password) async {
    print('input data: ' + username + "...." + password);
    final authenticationProvider =
    Provider.of<AuthProvider>(context, listen: false);
    //final sessionProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    authenticationProvider.updateDataLoadingIndicator(true);

    try {
      final authResponse = await authenticationProvider.authenticate(
          username: username, password: password);

      if (authResponse.status == 'SUCCESS') {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('tokenId', authResponse.data.token.toString());
        final currentTime = DateTime.now();
        final expirationTime = currentTime.add(Duration(hours: authResponse.data.expiry));
        sp.setString('session_expiry', expirationTime.toIso8601String());
        // AuthSessionModel authSessionModel = AuthSessionModel(
        //     authToken: authResponse.data.token.toString());
        // sessionProvider.saveLoginSession();
        // sessionProvider.saveUser(authSessionModel, authResponse.data.expiry);
        // sessionProvider.setAuthData(authResponse);
        Get.snackbar(
          'Success',
          'Logged in Successfully !',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        authenticationProvider.updateDataLoadingIndicator(false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardScreen()));
      }
    } catch (e) {
      authenticationProvider.updateDataLoadingIndicator(false);
      if (kDebugMode) {
        print('error message: $e');
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more complex email validation logic here
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add more complex password validation logic here
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/welcome.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 300,
                height: 450,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hey, Welcome!',
                        style: TextStyle(
                          fontSize: 24 /
                              MediaQuery.textScaleFactorOf(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GetTextFormField(
                      controller: emailController,
                      hintName: "name@company.com",
                      lebelName: "Email Address",
                      inputType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    GetTextFormField(
                      hintName: 'password',
                      controller: passwordTextEditingController,
                      inputType: TextInputType.text,
                      isObscureText: true,
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: authenticationProvider.isLoadingProfile
                          ? true
                          : false,
                      child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _authenticate(
                              emailController.text,
                              passwordTextEditingController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: accent,
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 /
                                MediaQuery.textScaleFactorOf(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
