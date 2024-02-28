import 'dart:async';

import 'package:employe_management_system/providers/leave_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/attendence_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utill/color_resources.dart';
import '../../utill/stored_images.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentTime;
  late String currentDate;
  late String greeting;
  String checkIn = '';
  String checkOut = '';
  String lat = '';
  String lan = '';
  String ipv6 = '';
  bool isLocMatched = false;
  String? token;
  late DateTime firstEntryTime;
  late DateTime lastCheckoutTime;
  final double officeLat = 23.791231408326187;
  final double officeLan = 90.40498901045726;
  final double threshold = 0.005;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final double geofenceRadius = 50.0; // Adjust the geofence radius as needed
  final info = NetworkInfo();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLocation();
    _startLocationTracking();
    // Initial update
    _updateDateTime();
    //get current entry status
    //_getCurrentAttendanceData();
    getProfileData();
    getLeaveData();
    // Start a periodic timer to update every minute
    Timer.periodic(Duration(seconds: 50), (timer) {
      _updateDateTime();
    });
  }

  Future<void> getProfileData() async {
    print('pppp: '+'call by checkout');
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    try {
      profileProvider.fetchProfile(token: token!);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      throw e;
    }
  }
  Future<void> getLeaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkIn = prefs.getString('checkInTime') ?? '';
    checkOut = prefs.getString('checkOutTime') ?? '';
    print('kkkkk: '+ checkIn+'....'+checkOut+'...'+Provider.of<AttendanceProvider>(context, listen: false).checkInTime.toString());
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    try {
      leaveProvider.fetchLeaveTypes(token: token!);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      throw e;
    }
  }

  Future<void> _checkLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Round the latitude and longitude values to 3 digits after the decimal point
    double latDifference = (currentPosition.latitude-officeLat).abs();
    double lanDifference = (currentPosition.longitude-officeLan).abs();

    setState(() {
      isLocMatched = (double.parse(latDifference.toStringAsFixed(3)) < threshold && double.parse(lanDifference.toStringAsFixed(3)) < threshold);
    });
    print('jjjjjjjj: '+ (latDifference.toStringAsFixed(3)+'__'+lanDifference.toStringAsFixed(3)));

  }

  Future<void> _startLocationTracking() async {
    geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,// Minimum distance for updates (in meters)
      ),
    ).listen((Position position) async {
      lat = position.latitude.toString();
      lan = position.longitude.toString();
      ipv6 = (await info.getWifiIP())!;
      String wifiname = (await info.getWifiName())!;
      print('position : $lat....$lan....$ipv6....$wifiname');
      if (await _isInsideGeofence(position)) {
        firstEntryTime = DateTime.now();
        if (kDebugMode) {
          print('First entry time: $firstEntryTime');
        }
        /// need to implement background notification for area area arrival 23.791231408326187, 90.40498901045726
        //_storeAttendance(position, 'checked_in');
      } else {
        lastCheckoutTime = DateTime.now();
        if (kDebugMode) {
          print('Last checkout time: $lastCheckoutTime');
        }
        /// need to implement background notification for area area leave
        //_storeAttendance(position, 'checked_out');
      }
    });
  }

  void _updateDateTime(){
    final now = DateTime.now();

    // Format time as "09 : 00 AM"
    currentTime = DateFormat.jm().format(now);

    // Format date as "01/01/2024, Monday"
    currentDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
    setState(() {

    });
    // // Determine the greeting based on the time
    // if (now.isBefore(DateTime(now.year, now.month, now.day, 12, 0))) {
    //   greeting = 'Good morning, \r\nMark your Attendance time.';
    // } else if (now.isBefore(DateTime(now.year, now.month, now.day, 18, 0))) {
    //   greeting = 'Good afternoon, \r\nEnsure lunch and sit again.';
    // } else if (now.isBefore(DateTime(now.year, now.month, now.day, 20, 0))) {
    //   greeting = 'Good evening, \r\nMark your sign out time.';
    // } else {
    //   greeting = 'Good night, \r\nRelax & have a sweet dream.';
    // }
    // setState(() {
    //
    // });
    // Update the UI with the new values
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
    if (kDebugMode) {
      print('distance: '+ distance.toString());
    }
    return distance <= geofenceRadius;
  }

  double calculateHours(String startTimes, String endTimes) {
    final DateFormat timeFormat = DateFormat('HH:mm');
    DateTime startTime = timeFormat.parse(startTimes);
    DateTime endTime = timeFormat.parse(endTimes);
    Duration difference = endTime.difference(startTime);
    double hours = difference.inMinutes / 60.0;
    return hours;
  }
  void showLateEntryDialog() {
    TextEditingController _entryReasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height/3,
          child: AlertDialog(
            title: Text('Late Entry Validation', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
            content: TextField(
              controller: _entryReasonController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Reason',
                hintText: 'Reason for being late'
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  Provider.of<AttendanceProvider>(context, listen: false).toggleCheckInOut(token, lat, lan, ipv6, _entryReasonController.text, Provider.of<ProfileProvider>(context, listen: false).userData!.data.attendance.checkin.toString());
                  //getProfileData();
                  Navigator.of(context).pop();
                  setState(() {
                    getProfileData();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void showEarlyExitDialog() {
    TextEditingController _exitReasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height/3,
          child: AlertDialog(
            title: Text('Early Exit Validation', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
            content: TextField(
              autofocus: true,
              controller: _exitReasonController,
              decoration: InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Reason for being early'
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  Provider.of<AttendanceProvider>(context, listen: false).toggleCheckInOut(token, lat, lan, ipv6, _exitReasonController.text, Provider.of<ProfileProvider>(context, listen: false).userData!.data.attendance.checkin.toString());
                  //getProfileData();
                  Navigator.of(context).pop();
                  setState(() {
                    getProfileData();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }



  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   int status = await BackgroundFetch.configure(BackgroundFetchConfig(
  //       minimumFetchInterval: 15,
  //       stopOnTerminate: false,
  //       enableHeadless: true,
  //       requiresBatteryNotLow: false,
  //       requiresCharging: false,
  //       requiresStorageNotLow: false,
  //       requiresDeviceIdle: false,
  //       requiredNetworkType: NetworkType.NONE
  //   ), (String taskId) async {  // <-- Event handler
  //     // This is the fetch-event callback.
  //     print("[BackgroundFetch] Event received $taskId");
  //       // Get the current location
  //       Position position = await geolocator.getCurrentPosition();
  //
  //       // Check if inside the geofence
  //       if (await _isInsideGeofence(position)) {
  //         firstEntryTime = DateTime.now();
  //         print('First entry time: $firstEntryTime');
  //         _storeAttendance(position, 'checked_in');
  //       } else {
  //         lastCheckoutTime = DateTime.now();
  //         print('Last checkout time: $lastCheckoutTime');
  //         _storeAttendance(position, 'checked_out');
  //       }
  //
  //       // Other background tasks...
  //
  //       // You can also update the UI if needed
  //       setState(() {
  //         // Update UI based on background tasks
  //       });
  //     // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //     // for taking too long in the background.
  //     BackgroundFetch.finish(taskId);
  //   }, (String taskId) async {  // <-- Task timeout handler.
  //     // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
  //     print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //     BackgroundFetch.finish(taskId);
  //   });
  //   print('[BackgroundFetch] configure success: $status');
  //   setState(() {
  //     _status = status;
  //   });
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }
  //
  // Future<void> _storeAttendance(Position position, String status) async {
  //   final now = DateTime.now();
  //   // Format date as "01/01/2024, Monday"
  //   String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
  //   final attendanceData =AttendanceDataModel(
  //     id: null,
  //     user_id: '007',
  //     latitude: position.latitude.toString(),
  //     longitude: position.longitude.toString(),
  //     timestamp: DateTime.now().millisecondsSinceEpoch,
  //     date: todayDate,
  //     status: status,
  //   );
  //   await DatabaseHelper.instance.insertUserData(attendanceData);
  // }
  //
  // Future<void> _getCurrentAttendanceData() async {
  //   final DateTime date = DateTime.now();
  //   // Convert the date to milliseconds since epoch to match the stored timestamp format
  //   final int startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
  //   final int endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;
  //
  //   final attendanceData = await DatabaseHelper.instance.getAllCurrentAttendanceData(startOfDay, endOfDay);
  //
  //   for (final entry in attendanceData) {
  //     final timestamp = entry['timestamp'] as int;
  //     final status = entry['status'] as String;
  //
  //     final formattedTime = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  //     print('Status: $status, Time: $formattedTime');
  //   }
  // }
  //
  // Future<void> _getTodayEntryData() async {
  //   try {
  //     final now = DateTime.now();
  //     // Format date as "01/01/2024, Monday"
  //     String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
  //     final entryData = await DatabaseHelper.instance.getEntry(todayDate);
  //
  //     if (entryData.isNotEmpty) {
  //       checkIn = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(entryData.first.timestamp));
  //       print('List: ' + entryData.first.timestamp.toString());
  //     } else {
  //       checkIn = '00:00 AM';
  //       // Handle case when no entry data is found for today
  //       print('No entry data found for today.');
  //     }
  //   } catch (error) {
  //     // Handle the error, e.g., print an error message
  //     print('Error fetching today\'s entry data: $error');
  //   }
  // }
  //
  // Future<void> _getTodayExitData() async {
  //   try {
  //     final now = DateTime.now();
  //     // Format date as "01/01/2024, Monday"
  //     String todayDate = DateFormat('MM/dd/yyyy, EEEE').format(now);
  //     final exitData = await DatabaseHelper.instance.getExit(todayDate);
  //
  //     if (exitData.isNotEmpty) {
  //       checkOut = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(exitData.first.timestamp));
  //       print('List: ' + exitData.first.timestamp.toString());
  //     } else {
  //       checkOut = '00:00 AM';
  //       // Handle case when no exit data is found for today
  //       print('No exit data found for today.');
  //     }
  //   } catch (error) {
  //     // Handle the error, e.g., print an error message
  //     print('Error fetching today\'s exit data: $error');
  //   }
  // }
  String convertTo12HourFormat(String dateTimeString) {
    // Parse the date-time string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the time in 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }
  @override
  Widget build(BuildContext context) {
    // Load data on app startup
    Provider.of<AttendanceProvider>(context, listen: false).loadAttendanceData();

    // Schedule automatic reset data task
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).autoResetData();
      Timer.periodic(Duration(hours: 12), (Timer t) {
        Provider.of<AttendanceProvider>(context, listen: false).autoResetData();
      });
    });
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profileData = profileProvider.userData;
    return Scaffold(
        body: profileData != null?SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35), // Adjust the radius as needed
                      bottomRight: Radius.circular(35), // Adjust the radius as needed
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.shade700.withOpacity(0.2), // Shadow color
                        spreadRadius: 8, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 4), // Offset in x and y directions
                      ),
                    ],
                  ),
                  child: Image.asset('assets/images/home_background.png'),
                ),
                Positioned(child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profileData.data.firstName != ''?'${profileData.data.firstName} ${profileData.data.lastName}':'name of user', style: GoogleFonts.mulish(color: Colors.white,
                                    fontSize: 25 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                SizedBox(height: 10,),
                                Text(profileData.data.designation != ''?profileData.data.designation:'Senior Software Engineer', style: GoogleFonts.mulish(
                                    fontSize: 15 / MediaQuery.textScaleFactorOf(context), color: Colors.white),),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(profileData.data.photo !=null?profileData.data.photo:'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg'),
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                    Text(currentTime, style: GoogleFonts.mulish(color: Colors.white,
                      fontSize: 24 / MediaQuery.textScaleFactorOf(context), ),),
                    Text(currentDate, style: GoogleFonts.mulish(color: Colors.white,
                        fontSize: 12 / MediaQuery.textScaleFactorOf(context)),),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.white.withOpacity(.2),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey), // Grey border
                                  borderRadius: BorderRadius.circular(5), // Rounded radius
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width *.42,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Attendance', style: GoogleFonts.mulish(fontSize: 15, color: Colors.white),)),
                                        )),
                                    Image.asset('assets/images/line.png'),
                                    SizedBox(height: 8,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Working day: ',style: GoogleFonts.mulish(color: Colors.white)),
                                          Text(profileData.data.attendance.workingDays.toString() != ''?profileData.data.attendance.workingDays.toString():'N/A',style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('On time: ',style: GoogleFonts.mulish(color: Colors.white)),
                                          Text(profileData.data.attendance.onTime.toString() != ''?profileData.data.attendance.onTime.toString():'N/A',style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Late entry: ', style: GoogleFonts.mulish(color: Colors.white),),
                                          Text(profileData.data.attendance.lateTime.toString() != ''?profileData.data.attendance.lateTime.toString():'N/A', style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.white.withOpacity(.2),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey), // Grey border
                                  borderRadius: BorderRadius.circular(5), // Rounded radius
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width *.42,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('Leave', style: GoogleFonts.mulish(fontSize: 15, color: Colors.white),),
                                        )),
                                    Image.asset('assets/images/line.png'),
                                    SizedBox(height: 8,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Leave: ',style: GoogleFonts.mulish(color: Colors.white)),
                                          Text(profileData.data.leave.total.toString() != ''?profileData.data.leave.total.toString():'N/A',style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Leave Use: ',style: GoogleFonts.mulish(color: Colors.white)),
                                          Text(profileData.data.leave.used.toString() != ''?profileData.data.leave.used.toString():'N/A',style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Remaining: ', style: GoogleFonts.mulish(color: Colors.white),),
                                          Text((profileData.data.leave.total-profileData.data.leave.used).toString(), style: GoogleFonts.mulish(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                )
                )
              ],),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  DateTime now = DateTime.now();
                  DateTime entryTime = DateFormat('hh:mm a').parse(profileData.data.settings.office.startTime);
                  DateTime exitTime = DateFormat('hh:mm a').parse(profileData.data.settings.office.endTime);

                  bool isAfterEntryTime = now.isAfter(entryTime);
                  bool isBeforeExitTime = now.isBefore(exitTime);
                  if(profileData.data.attendance.checkin == null && isAfterEntryTime){
                    showLateEntryDialog();
                  }else if(profileData.data.attendance.checkin != null &&
                      profileData.data.attendance.checkout == null
                      && isBeforeExitTime){
                    showEarlyExitDialog();
                  }else{
                    showEarlyExitDialog();
                  }
                },
                child: Container(
                    height: 170, width:170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      color: Colors.white,

                    ),
                    //square box; equal height and width so that it won't look like oval
                    child: Stack(
                        alignment: Alignment.center,
                        children:[
                          Image.asset('assets/images/rounded_btn.png', height: 200, width: 200,),
                          Positioned(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Consumer<AttendanceProvider>(
                                  builder: (context, provider, child) {
                                    return Image.asset(profileData.data.attendance.checkin == null
                                        ? Images.checkInBtn : Images.checkoutBtn);
                                  },
                                ),
                              ],
                            ),
                          )
                        ] )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: isLocMatched? Colors.green:Colors.redAccent, size: 20,),
                  Text(isLocMatched?'Location: Office Building': 'Location: Not in Office Building' ,style: TextStyle(
                      fontSize: 13 / MediaQuery.textScaleFactorOf(context), color: isLocMatched?Colors.green:Colors.redAccent,letterSpacing: 1.5),),
                ],
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(Images.checkin),
                        SizedBox(width: 5,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check in', style: TextStyle(
                                fontSize: 14 / MediaQuery.textScaleFactorOf(context),
                                color: Colors.green[900], fontWeight: FontWeight.bold),),
                            Consumer<ProfileProvider>(
                              builder: (context, provider, child) {
                                return Text(provider.userData!.data.attendance.checkin == null?'--:--': convertTo12HourFormat(provider.userData!.data.attendance.checkin),
                                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(Images.checkout),
                        SizedBox(width: 5,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check out', style: TextStyle(
                                fontSize: 14 / MediaQuery.textScaleFactorOf(context),
                                color: Colors.green[900], fontWeight: FontWeight.bold)),
                            Consumer<ProfileProvider>(
                              builder: (context, provider, child) {
                                return Text(provider.userData!.data.attendance.checkout == null?'--:--': convertTo12HourFormat(provider.userData!.data.attendance.checkout),
                                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14));
                              },
                            ),

                          ],
                        )

                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(Images.total),
                        SizedBox(width: 5,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total hours', style: TextStyle(
                                fontSize: 14 / MediaQuery.textScaleFactorOf(context),
                                color: Colors.green[900], fontWeight: FontWeight.bold),),
                            Consumer<AttendanceProvider>(
                              builder: (context, provider, child) {
                                return Text(provider.calculateTotalHours(profileData.data.attendance.checkin.toString(), profileData.data.attendance.checkout.toString()),
                                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14));
                              },
                            ),

                          ],
                        )

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ):Center(child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.green,
          size: 30,
        ),));
  }
}

