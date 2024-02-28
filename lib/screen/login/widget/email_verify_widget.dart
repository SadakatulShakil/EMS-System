import 'package:employe_management_system/screen/login/widget/register_widget.dart.dart';
import 'package:employe_management_system/screen/login/widget/text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../utill/color_resources.dart';

class EmailVerifyPage extends StatefulWidget {
  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50,),
              Image.asset(
                'assets/images/logo.png',
                height: 180,
                width: 180,
              ),
              SizedBox(height: 50,),
              Text(
                'Verify Your Identity,',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              SizedBox(height: 20),
              // Add your sign-in form widgets here
              // For example, you can use TextFormField, ElevatedButton, etc.
              GetTextFormField(
                //onChangeText: dataProvider.updateTextFieldUsersEmail,
                controller: userNameTextEditingController,
                hintName: "User name",
                inputType: TextInputType.emailAddress,
              ),
              GetTextFormField(
                hintName: 'Email',
                controller: emailTextEditingController,
                inputType: TextInputType.text,
              ),
              SizedBox(height: 20),
              Visibility(
                visible: authenticationProvider.isLoadingProfile?true:false,
                child: Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterWidgetScreen(backExits: false)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: accentLight, // Set the background color here
                ),
                child: Text('Verify Now', style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
