import 'package:flutter/material.dart';
import '../../utill/color_resources.dart';
class ProfileScreen extends StatefulWidget {
  bool backExits;
  ProfileScreen({Key? key, required this.backExits}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hey! Haasan Masud', style: TextStyle(fontSize: 25 / MediaQuery.textScaleFactorOf(context)),),
                        SizedBox(height: 10,),
                        Text('Welcome to Softwind Tech LTD.', style: TextStyle(fontSize: 18 / MediaQuery.textScaleFactorOf(context)),),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset('assets/images/user.png',height: 70,width: 70,)
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

