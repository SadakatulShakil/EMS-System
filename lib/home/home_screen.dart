import 'dart:async';

import 'package:flutter/material.dart';
import '../../utill/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:stream/stream.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentTime;
  late String currentDate;
  late String greeting;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
// Initial update
    _updateDateTime();

    // Start a periodic timer to update every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();

    // Format time as "09 : 00 AM"
    currentTime = DateFormat.jm().format(now);

    // Format date as "01/01/2024, Monday"
    currentDate = DateFormat('MM/dd/yyyy, EEEE').format(now);

    // Determine the greeting based on the time
    if (now.isBefore(DateTime(now.year, now.month, now.day, 12, 0))) {
      greeting = 'Good morning, \r\nMark your Attendance time.';
    } else if (now.isBefore(DateTime(now.year, now.month, now.day, 18, 0))) {
      greeting = 'Good afternoon, \r\nEnsure lunch and sit again.';
    } else if (now.isBefore(DateTime(now.year, now.month, now.day, 20, 0))) {
      greeting = 'Good evening, \r\nMark your sign out time.';
    } else {
      greeting = 'Good night, \r\nRelax & have a sweet dream.';
    }

    setState(() {}); // Update the UI with the new values
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
                        Text(greeting, style: TextStyle(
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
              Text(currentTime, style: TextStyle(
                fontSize: 30 / MediaQuery.textScaleFactorOf(context), ),),
              Text(currentDate, style: TextStyle(
                  fontSize: 15 / MediaQuery.textScaleFactorOf(context), color: Colors.grey[600]),),
              SizedBox(height:16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*.4,
                      child: Card(
                          child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: accent,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Align(
                                  alignment: Alignment.center,
                                    child: Text('Attendance', style: TextStyle(fontSize: 18, color: Colors.white),)),
                              )),
                          SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Working day: ',style: TextStyle(color: Colors.blueAccent)),
                                Text('25',style: TextStyle(color: Colors.blueAccent)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('On time: ',style: TextStyle(color: Colors.green)),
                                Text('20',style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Late entry: ', style: TextStyle(color: Colors.redAccent),),
                                Text('5', style: TextStyle(color: Colors.redAccent)),
                              ],
                            ),
                          ),
                          SizedBox(height: 8,),
                        ],
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*.4,
                      child: Card(
                          child: Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: accent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text('Leave', style: TextStyle(fontSize: 18, color: Colors.white),)),
                                  )),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Leave: ',style: TextStyle(color: Colors.blueAccent)),
                                    Text('25',style: TextStyle(color: Colors.blueAccent)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Leave Use: ',style: TextStyle(color: Colors.green)),
                                    Text('12',style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Remaining: ', style: TextStyle(color: Colors.redAccent),),
                                    Text('13', style: TextStyle(color: Colors.redAccent)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: 20,),
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

