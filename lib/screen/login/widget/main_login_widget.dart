import 'package:employe_management_system/Model/auth_session_model.dart';
import 'package:employe_management_system/screen/login/widget/text_from_field.dart';

import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/auth_session_provider.dart';
import '../../../utill/color_resources.dart';
import '../../home/dashboard_screen.dart';
import 'package:provider/provider.dart';


class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  Future<void> _authenticate(String username, String password) async {
    final authenticationProvider = Provider.of<AuthProvider>(context, listen: false);
    final sessionProvider = Provider.of<AuthSessionProvider>(context, listen: false);


      try {
        final authResponse = await authenticationProvider.authenticate(
            username: username, password: password);


        if (authResponse.status == 'SUCCESS') {
          AuthSessionModel authSessionModel = AuthSessionModel(authToken: authResponse.data.token.toString(), userAccountType: authResponse.data.user.name);
          sessionProvider.saveLoginSession();
          sessionProvider.saveUser(authSessionModel, authResponse.data.expireAt);
          final snackBar = SnackBar(
            backgroundColor: Colors.black,
            content: Text('Login successfully'),
            duration: Duration(seconds: 1),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashBoardScreen()));
        }
      } catch (e) {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username & Password does not match'),
          duration: Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30,),
              Text(
                'Log In,',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              SizedBox(height: 20),
              // Add your sign-in form widgets here
              // For example, you can use TextFormField, ElevatedButton, etc.
              GetTextFormField(
                //onChangeText: dataProvider.updateTextFieldUsersEmail,
                controller: userNameTextEditingController,
                hintName: "user id",
                inputType: TextInputType.emailAddress,
              ),
              GetTextFormField(
                hintName: 'password',
                controller: passwordTextEditingController,
                inputType: TextInputType.text,
                isObscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement sign-in logic here
                  _authenticate(userNameTextEditingController.text, passwordTextEditingController.text);
                },
                style: ElevatedButton.styleFrom(
                  primary: accentLight, // Set the background color here
                ),
                child: Text('Login In',style: TextStyle(color: primaryColor)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
