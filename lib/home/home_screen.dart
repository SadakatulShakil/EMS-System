import 'package:flutter/material.dart';
import '../../utill/color_resources.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hey, Haasan Masud!', style: TextStyle(
                            fontSize: 25 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Text('Good Morning, Mark your Attendance.', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context), color: Colors.grey[600]),),
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png',),
                      radius: 30,
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text('09 : 00 AM', style: TextStyle(fontSize: 30 / MediaQuery.textScaleFactorOf(context), ),),
              Text('01/01/2024, Monday', style: TextStyle(
                  fontSize: 15 / MediaQuery.textScaleFactorOf(context), color: Colors.grey[600]),),

              SizedBox(height: 100,),
              Container(
                  height: 170, width:170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    color: Colors.white,

                  ),
                  //square box; equal height and width so that it won't look like oval
                  child: Stack(
                      children:[
                    Image.asset('assets/images/button.png', height: 200, width: 200,),
                    Positioned(
                      left: 55,
                      top: 55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.ads_click, color: Colors.green,),
                          SizedBox(height: 8,),
                          Text('Check in', style: TextStyle(
                              fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                              color: Colors.green[600])),
                        ],
                      ),
                    )
                  ] )
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.ads_click, color: Colors.green, size: 40,),
                        Text('--:--', style: TextStyle(
                            fontSize: 18 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.grey[600], fontWeight: FontWeight.bold),),
                        Text('Check in', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.green[600]),),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.ads_click, color: Colors.green,size: 40),
                        Text('--:--', style: TextStyle(
                            fontSize: 18 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.grey[600], fontWeight: FontWeight.bold),),
                        Text('Check out', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.green[600])),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.ads_click, color: Colors.green, size: 40),
                        Text('--:--', style: TextStyle(
                            fontSize: 18 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.grey[600], fontWeight: FontWeight.bold),),
                        Text('Total hours', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.green[600]),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

