import 'package:employe_management_system/screen/login/widget/text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../utill/color_resources.dart';

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  // Future<void> _authenticate(String username, String password) async {
  //   final authenticationProvider =
  //       Provider.of<AuthProvider>(context, listen: false);
  //   final sessionProvider =
  //       Provider.of<AuthSessionProvider>(context, listen: false);
  //
  //   authenticationProvider.updateDataLoadingIndicator(true);
  //
  //   try {
  //     final authResponse = await authenticationProvider.authenticate(
  //         username: username, password: password);
  //
  //     if (authResponse.status == 'SUCCESS') {
  //       AuthSessionModel authSessionModel = AuthSessionModel(
  //           authToken: authResponse.data.token.toString(),
  //           userAccountType: authResponse.data.user.name);
  //       sessionProvider.saveLoginSession();
  //       sessionProvider.saveUser(authSessionModel, authResponse.data.expireAt);
  //       Get.snackbar(
  //         'Success',
  //         'Logged in Successfully !',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //         borderRadius: 10,
  //         margin: EdgeInsets.all(10),
  //       );
  //       authenticationProvider.updateDataLoadingIndicator(false);
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => DashBoardScreen()));
  //     }
  //   } catch (e) {
  //     authenticationProvider.updateDataLoadingIndicator(false);
  //     if (kDebugMode) {
  //       print('error message: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Log In,',
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
                    // Implement sign-in logic here
                    // _authenticate(userNameTextEditingController.text,
                    //     passwordTextEditingController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accentLight, // Set the background color here
                  ),
                  child: Text('Login In', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
