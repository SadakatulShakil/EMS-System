import 'dart:async';

import 'package:employe_management_system/Model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../utill/color_resources.dart';
import '../LocalDatabase/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';

import '../utill/stored_images.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentTime;
  late String currentDate;
  late String greeting;
  String checkIn = '00:00 AM';
  String checkOut = '00:00 AM';
  late DateTime firstEntryTime;
  late DateTime lastCheckoutTime;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final double geofenceRadius = 50.0; // Adjust the geofence radius as needed
  final String apiUrl = 'YOUR_API_ENDPOINT';
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    //_startLocationTracking();
// Initial update
    _updateDateTime();
    //get current entry status
    _getCurrentAttendanceData();
    _getTodayEntryData();
    _getTodayExitData();

    // Start a periodic timer to update every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDateTime();
    });
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {  // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
        // Get the current location
        Position position = await geolocator.getCurrentPosition();

        // Check if inside the geofence
        if (await _isInsideGeofence(position)) {
          firstEntryTime = DateTime.now();
          print('First entry time: $firstEntryTime');
          _storeAttendance(position, 'checked_in');
        } else {
          lastCheckoutTime = DateTime.now();
          print('Last checkout time: $lastCheckoutTime');
          _storeAttendance(position, 'checked_out');
        }

        // Other background tasks...

        // You can also update the UI if needed
        setState(() {
          // Update UI based on background tasks
        });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }
  // Background fetch callback function
  // void _backgroundFetchCallback() async {
  //   print('Background fetch executed.');
  //
  //   // Get the current location
  //   Position position = await geolocator.getCurrentPosition();
  //
  //   // Check if inside the geofence
  //   if (await _isInsideGeofence(position)) {
  //     firstEntryTime = DateTime.now();
  //     print('First entry time: $firstEntryTime');
  //     _storeAttendance(position, 'checked_in');
  //   } else {
  //     lastCheckoutTime = DateTime.now();
  //     print('Last checkout time: $lastCheckoutTime');
  //     _storeAttendance(position, 'checked_out');
  //   }
  //
  //   // Other background tasks...
  //
  //   // You can also update the UI if needed
  //   setState(() {
  //     // Update UI based on background tasks
  //   });
  //
  //   // Call finish to signal that the background fetch is complete
  //   BackgroundFetch.finish();
  // }

  Future<void> _startLocationTracking() async {
    geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,// Minimum distance for updates (in meters)
      ),
    ).listen((Position position) async {
      if (await _isInsideGeofence(position)) {
        firstEntryTime = DateTime.now();
        print('First entry time: $firstEntryTime');
        _storeAttendance(position, 'checked_in');
        setState(() {

        });
      } else {
        lastCheckoutTime = DateTime.now();
        print('Last checkout time: $lastCheckoutTime');
        _storeAttendance(position, 'checked_out');
        setState(() {

        });
      }
    });
  }

  Future<bool> _isInsideGeofence(Position position) async {
    // Replace with your geofence center coordinates //23.79141428281947, 90.40498680319003
    double geofenceCenterLatitude = 23.79141428281947;
    double geofenceCenterLongitude = 90.40498680319003;

    double distance = await geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      geofenceCenterLatitude,
      geofenceCenterLongitude,
    );
    print('distance: '+ distance.toString());
    return distance <= geofenceRadius;
  }
  Future<void> _storeAttendance(Position position, String status) async {
    final now = DateTime.now();
    // Format date as "01/01/2024, Monday"
    String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
    final attendanceData =AttendanceDataModel(
      id: null,
      user_id: '007',
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      date: todayDate,
      status: status,
    );
    await DatabaseHelper.instance.insertUserData(attendanceData);
  }

  Future<void> _getCurrentAttendanceData() async {
    final DateTime date = DateTime.now();
    // Convert the date to milliseconds since epoch to match the stored timestamp format
    final int startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final int endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    final attendanceData = await DatabaseHelper.instance.getAllCurrentAttendanceData(startOfDay, endOfDay);

    for (final entry in attendanceData) {
      final timestamp = entry['timestamp'] as int;
      final status = entry['status'] as String;

      final formattedTime = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
      print('Status: $status, Time: $formattedTime');
    }
    setState(() {});
  }

  double calculateHours(String startTimes, String endTimes) {
    final DateFormat timeFormat = DateFormat('HH:mm');
    DateTime startTime = timeFormat.parse(startTimes);
    DateTime endTime = timeFormat.parse(endTimes);
    Duration difference = endTime.difference(startTime);
    double hours = difference.inMinutes / 60.0;
    return hours;
  }

  Future<void> _getTodayEntryData() async {
    try {
      final now = DateTime.now();
      // Format date as "01/01/2024, Monday"
      String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
      final entryData = await DatabaseHelper.instance.getEntry(todayDate);

      if (entryData.isNotEmpty) {
        checkIn = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(entryData.first.timestamp));
        print('List: ' + entryData.first.timestamp.toString());
        setState(() {});
      } else {
        checkIn = '00:00 AM';
        // Handle case when no entry data is found for today
        print('No entry data found for today.');
        setState(() {});
      }
    } catch (error) {
      // Handle the error, e.g., print an error message
      print('Error fetching today\'s entry data: $error');
    }
  }

  Future<void> _getTodayExitData() async {
    try {
      final now = DateTime.now();
      // Format date as "01/01/2024, Monday"
      String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
      final exitData = await DatabaseHelper.instance.getExit(todayDate);

      if (exitData.isNotEmpty) {
        checkOut = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(exitData.first.timestamp));
        print('List: ' + exitData.first.timestamp.toString());
        setState(() {});
      } else {
        checkOut = '00:00 AM';
        // Handle case when no exit data is found for today
        print('No exit data found for today.');
        setState(() {});
      }
    } catch (error) {
      // Handle the error, e.g., print an error message
      print('Error fetching today\'s exit data: $error');
    }
  }


  // Future<void> _storeAttendance() async {
  //   try {
  //     // Replace with your API request to store attendance
  //     await http.post(
  //       Uri.parse(apiUrl),
  //       // Include any necessary headers, body, etc.
  //     );
  //
  //     print('Attendance stored successfully!');
  //   } catch (e) {
  //     print('Error storing attendance: $e');
  //   }
  // }

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
                      left: 53,
                      top: 53,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          checkIn != '00:00 AM'? Image.asset(Images.checkout):Image.asset(Images.checkin),
                          SizedBox(height: 8,),
                          checkIn != '00:00 AM'?Text('Check out', style: TextStyle(
                              fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                              color: Colors.green[600])):Text('Check in', style: TextStyle(
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
                        Image.asset(Images.checkin),
                        Text(checkIn == '00:00 AM' ? '--:--': checkIn, style: TextStyle(
                            fontSize: 18 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.grey[600], fontWeight: FontWeight.bold),),
                        Text('Check in', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.green[600]),),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(Images.checkout),
                        Text(checkOut == '00:00 AM' ? '--:--': checkOut, style: TextStyle(
                            fontSize: 18 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.grey[600], fontWeight: FontWeight.bold),),
                        Text('Check out', style: TextStyle(
                            fontSize: 15 / MediaQuery.textScaleFactorOf(context),
                            color: Colors.green[600])),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(Images.total),
                        Text(checkOut != '00:00 AM' ? calculateHours(checkIn, checkOut).toStringAsFixed(1) : '--:--', style: TextStyle(
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

