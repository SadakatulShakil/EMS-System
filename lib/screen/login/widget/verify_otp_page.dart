import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/leave_provider.dart';
import '../../../utill/color_resources.dart';
import '../login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpScreen extends StatefulWidget {
  String email;
  VerifyOtpScreen(this.email);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  String? token;
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Timer _timer;
  bool _isResendButtonVisible = false;
  int _secondsRemaining = 120;
  List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendButtonVisible = true;
          _timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    // Implement your resend code functionality here
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.sendOtp(widget.email.trim(), context);
    setState(() {
      _isResendButtonVisible = false;
      _secondsRemaining = 120; // Reset the timer
      startTimer(); // Start the timer again
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more complex email validation logic here
    return null;
  }

  void _verifyOtp() async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    if(_formKey.currentState!.validate()){
      String otp = _controllers.map((controller) => controller.text).join();
      authProvider.verifyOtp(otp.trim(), passwordController.text.trim()).then((value){

        if(value.status == 'SUCCESS'){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
                (route) => false, // Removes all routes from the stack
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    return leaveProvider.isLoading
        ? Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: Colors.green,
              size: 30,
            ),
          )
        : Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF66A690),
        title: Text('Verify OTP',style: GoogleFonts.mulish()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('Enter the code we sent ${widget.email} and set a new password.', textAlign: TextAlign.center,  style: GoogleFonts.mulish(
                    fontSize: 18 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w400,
                    color: cyanColor,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
                  child: Text('OTP',
                    style: GoogleFonts.mulish(
                      fontSize: 16 /
                          MediaQuery.textScaleFactorOf(context),
                      fontWeight: FontWeight.w500,
                      color: cyanColor,
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                          (index) => SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _controllers[index],
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counter: Offstage(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onChanged: (String value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            // You can handle the value changes here
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Timer: $_secondsRemaining seconds', style: GoogleFonts.mulish(color: Colors.red),),
                      SizedBox(width: 10,),
                      if (_isResendButtonVisible)
                        InkWell(
                            onTap: (){
                              _resendCode();
                            },
                            child: Text('Resend Code', style: GoogleFonts.mulish(color: Colors.blue),))
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Text('Password',   style: GoogleFonts.mulish(
                    fontSize: 16 /
                        MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                    color: cyanColor,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',hintStyle:GoogleFonts.mulish(
                      fontSize: 14 /
                          MediaQuery.textScaleFactorOf(context),
                      color: hintColor,
                    ),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: InkWell(
                    onTap: () async{
                      // Perform registration action here
                      _verifyOtp();
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
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
