import 'package:employe_management_system/screen/login/widget/verify_otp_page.dart';
import 'package:employe_management_system/screen/login/widget/text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../providers/auth_provider.dart';
import '../../../utill/color_resources.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utill/dimensions.dart';
class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();


  bool validateEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more complex email validation logic here
    return null;
  }

  void _applyForOtp() async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if(_formKey.currentState!.validate()){
      if (validateEmail(emailController.text.trim())) {

        authProvider.sendOtp(emailController.text.trim(), context);

      }else{
        Get.snackbar(
          'Warning',
          'The email format is incorrect.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return authenticationProvider.isLoadingProfile ? Scaffold(
      body: Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.green,
          size: 30,
        ),
      ),
    ): Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF66A690),
        title: Text('Forget Password'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('Enter your email we will sent you 6 digits verification code.', textAlign: TextAlign.center,  style: GoogleFonts.mulish(
                    fontSize: 18 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w400,
                    color: cyanColor,
                  ),),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
                  child: Text('Email',   style: GoogleFonts.mulish(
                    fontSize: 16 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                    color: cyanColor,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 18),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',hintStyle:GoogleFonts.mulish(
                      fontSize: 14 /
                          MediaQuery.textScaleFactorOf(context),
                      color: hintColor,
                    ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: InkWell(
                    onTap: () async{
                      // Perform registration action here
                      _applyForOtp();
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          'Verify Now',
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
