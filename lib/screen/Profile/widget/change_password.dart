import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/auth_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../login/login_screen.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _isPasswordVisible = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token;
  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter old password';
    }
    // You can add more complex email validation logic here
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    // You can add more complex email validation logic here
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm new password';
    }
    // You can add more complex email validation logic here
    return null;
  }

  Future<void> _updatePassword() async {
    final resetProvider = Provider.of<AuthProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    try {
      resetProvider.resetPassword(token!, _oldPasswordController.text, _passwordController.text, _confirmPasswordController.text).then((value){
        if(value.status == 'SUCCESS'){
          Get.snackbar(
            'Success',
            value.message.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          final logResponse = resetProvider.logout(token: token!);
          logResponse.then((value)async{
            if(value.status == 'SUCCESS'){
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setString('tokenId', '');
              sp.setString('session_expiry', '');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                    (route) => false, // Removes all routes from the stack
              );
            }
          });
        }else{
          Get.snackbar(
            'Warning',
            value.message.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar:AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF66A690),
          title: Text('Change Password'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        key: _scaffoldKey,
        body:Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text('Old password',   style: GoogleFonts.mulish(
                    fontSize: 16 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                  ),),
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                        hintText: 'Enter old password',hintStyle:GoogleFonts.mulish(
                      fontSize: 14 /
                          MediaQuery.textScaleFactorOf(context),
                      color: hintColor,
                    )
                    ),
                    validator: _validateOldPassword,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20.0),
                  Text('New Password',   style: GoogleFonts.mulish(
                    fontSize: 16 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                  ),),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: 'Enter new password',hintStyle:GoogleFonts.mulish(
                      fontSize: 14 /
                          MediaQuery.textScaleFactorOf(context),
                      color: hintColor,
                    )
                    ),
                    validator: _validateNewPassword,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20.0),
                  Text('Confirm New Password',   style: GoogleFonts.mulish(
                    fontSize: 16 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                  ),),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                        hintText: 'Confirm new password',hintStyle:GoogleFonts.mulish(
                      fontSize: 14 /
                          MediaQuery.textScaleFactorOf(context),
                      color: hintColor,
                    )
                    ),
                    validator: _validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () async{
                      if (_formKey.currentState!.validate()) {
                        if(_passwordController.text == _confirmPasswordController.text){
                          _updatePassword();
                        }else{
                          Get.snackbar(
                            'Warning',
                            'Your password did not match',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            borderRadius: 10,
                            margin: EdgeInsets.all(10),
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          'Update Now',
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        )
    );
  }
  }

