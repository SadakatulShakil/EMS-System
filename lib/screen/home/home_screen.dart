import 'dart:async';

import 'package:employe_management_system/providers/leave_provider.dart';
import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/attendence_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/profile_provider.dart';
import '../Profile/profile_screen.dart';

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
  bool isLoading = false;
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
    getProfileData();
    getLeaveData();
    // Start a periodic timer to update every minute
    Timer.periodic(Duration(seconds: 50), (timer) {
      _updateDateTime();
    });
  }

  Future<void> getProfileData() async {
    print('==========================>>');

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");

    try {
      await profileProvider.fetchProfile(token: token!);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      // Handle error, e.g., show error message to the user
    }
  }

  Future<void> getLeaveData() async {
    setState(() {
      isLoading = true; // Show loader
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkIn = prefs.getString('checkInTime') ?? '';
    checkOut = prefs.getString('checkOutTime') ?? '';

    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");

    try {
      await leaveProvider.fetchLeaveTypes(token: token!);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching leave data: $e');
      }
      // Handle error, e.g., show error message to the user
    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }

  Future<void> _checkLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Round the latitude and longitude values to 3 digits after the decimal point
    double latDifference = (currentPosition.latitude - officeLat).abs();
    double lanDifference = (currentPosition.longitude - officeLan).abs();

    setState(() {
      isLocMatched =
          (double.parse(latDifference.toStringAsFixed(3)) < threshold &&
              double.parse(lanDifference.toStringAsFixed(3)) < threshold);
    });
    print('jjjjjjjj: ' +
        (latDifference.toStringAsFixed(3) +
            '__' +
            lanDifference.toStringAsFixed(3)));
  }

  Future<void> _startLocationTracking() async {
    geolocator
        .getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Minimum distance for updates (in meters)
      ),
    )
        .listen((Position position) async {
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

  void _updateDateTime() {
    final now = DateTime.now();

    // Format time as "09 : 00 AM"
    currentTime = DateFormat.jm().format(now);

    // Format date as "01/01/2024, Monday"
    currentDate = DateFormat('dd MMMM, yyyy, EEEE').format(now);
    setState(() {});
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
      print('distance: ' + distance.toString());
    }
    return distance <= geofenceRadius;
  }

  String calculateHours(String startTimes) {
    if (startTimes == 'null') {
      return '00 hr 00 min';
    }
    try {
      DateTime now = DateTime.now();
      final DateFormat timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedNow = timeFormat.format(now);
      DateTime checkIn = timeFormat.parse(startTimes);
      DateTime checkOut = timeFormat.parse(formattedNow);

      Duration duration = checkOut.difference(checkIn);

      int hours = duration.inHours;
      int minutes = (duration.inMinutes % 60);

      return '$hours hr ${minutes.toString().padLeft(2, '0')} min';
    } catch (e) {
      return 'Error calculating total hours';
    }
  }

  void showLateEntryDialog() {
    TextEditingController _entryReasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: AlertDialog(
            title: Text(
              'Entry Validation',
              textAlign: TextAlign.center,
              style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: _entryReasonController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Remarks', hintText: 'Drop a remarks'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit', style: GoogleFonts.mulish()),
                onPressed: () async {
                  await submitDialog(_entryReasonController.text);
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
          height: MediaQuery.of(context).size.height / 3,
          child: AlertDialog(
            title: Text(
              'Exit Validation',
              textAlign: TextAlign.center,
              style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              autofocus: true,
              controller: _exitReasonController,
              decoration: InputDecoration(
                  labelText: 'Remarks', hintText: 'Drop a remarks'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit', style: GoogleFonts.mulish()),
                onPressed: () {
                  // Make the onPressed callback async
                  submitDialog(_exitReasonController.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Function to submit the dialog
  Future<void> submitDialog(String reason) async {
    print('======================>');
    Provider.of<AttendanceProvider>(context, listen: false)
        .toggleCheckInOut(
            context,
            token,
            lat,
            lan,
            ipv6,
            reason,
            Provider.of<ProfileProvider>(context, listen: false)
                .userData!
                .data
                .attendance
                .checkin
                .toString())
        .then((value) {
      getProfileData();
    });
    // Close the dialog
    Navigator.pop(context);
  }

  // Function to submit the dialog
  Future<void> legalSubmit(BuildContext context, String reason) async {
    print('======================>');
    Provider.of<AttendanceProvider>(context, listen: false)
        .toggleCheckInOut(
            context,
            token,
            lat,
            lan,
            ipv6,
            reason,
            Provider.of<ProfileProvider>(context, listen: false)
                .userData!
                .data
                .attendance
                .checkin
                .toString())
        .then((value) {
      getProfileData();
    });
  }

  String convertToMainFormat(String dateTimeString) {
    try {
      // Check if the input string already includes AM/PM format
      print('-+-+-+  $dateTimeString');
      if (dateTimeString.contains('AM') || dateTimeString.contains('PM')) {
        // No need to convert, return the original string
        DateTime now = DateTime.now();

        String fullDateTimeString =
            DateFormat('yyyy-MM-dd').format(now) + ' ' + dateTimeString;
        print('-+-?-+  $fullDateTimeString');
        DateTime dateTime =
            DateFormat('yyyy-MM-dd hh:mm a').parse(fullDateTimeString);

        // Format the DateTime object to the desired format
        String formattedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        print('-+-?-+  $formattedTime');
        return formattedTime;
      } else {
        // Parse the date-time string
        return dateTimeString;
      }
    } catch (e) {
      // Handle parsing errors
      print('Error converting to 12-hour format: $e');
      // Return a default value or handle the error in another way
      return 'Invalid Date';
    }
  }

  String convertTo12HourFormat(String dateTimeString) {
    try {
      // Check if the input string already includes AM/PM format
      if (dateTimeString.contains('AM') || dateTimeString.contains('PM')) {
        // No need to convert, return the original string
        return dateTimeString;
      } else {
        // Parse the date-time string
        DateTime dateTime = DateTime.parse(dateTimeString);

        // Format the time in 12-hour format with AM/PM
        String formattedTime = DateFormat('hh:mm a').format(dateTime);

        return formattedTime;
      }
    } catch (e) {
      // Handle parsing errors
      print('Error converting to 12-hour format: $e');
      // Return a default value or handle the error in another way
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load data on app startup
    Provider.of<AttendanceProvider>(context, listen: false)
        .loadAttendanceData();

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
      backgroundColor: Color(0xFFF6F8FE),
        body: (!profileProvider.isProLoading && profileData != null)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              // Adjust the radius as needed
                              bottomRight: Radius.circular(
                                  35), // Adjust the radius as needed
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.shade700.withOpacity(0.2),
                                // Shadow color
                                spreadRadius: 8,
                                // Spread radius
                                blurRadius: 7,
                                // Blur radius
                                offset: Offset(
                                    0, 4), // Offset in x and y directions
                              ),
                            ],
                          ),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/home_background.png',
                                fit: BoxFit.cover,
                              )),
                        ),
                        Positioned(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileData.data.firstName != ''
                                              ? '${profileData.data.firstName} ${profileData.data.lastName}'
                                              : 'name of user',
                                          style: GoogleFonts.mulish(
                                              color: Colors.white,
                                              fontSize: 25 /
                                                  MediaQuery.textScaleFactorOf(
                                                      context),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          profileData.data.designation != ''
                                              ? profileData.data.designation
                                              : 'Senior Software Engineer',
                                          style: GoogleFonts.mulish(
                                              fontSize: 15 /
                                                  MediaQuery.textScaleFactorOf(
                                                      context),
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen(true),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(profileData
                                                  .data.photo !=
                                              null
                                          ? profileData.data.photo
                                          : 'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg'),
                                      radius: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              currentTime,
                              style: GoogleFonts.mulish(
                                color: Colors.white,
                                fontSize:
                                    24 / MediaQuery.textScaleFactorOf(context),
                              ),
                            ),
                            Text(
                              currentDate,
                              style: GoogleFonts.mulish(
                                  color: Colors.white,
                                  fontSize: 12 /
                                      MediaQuery.textScaleFactorOf(context)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      color: Colors.white.withOpacity(.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          // Grey border
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded radius
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .42,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Attendance',
                                                        style:
                                                            GoogleFonts.mulish(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                )),
                                            Image.asset(
                                                'assets/images/line.png'),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Working day: ',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                  Text(
                                                      profileData
                                                                  .data
                                                                  .attendance
                                                                  .workingDays
                                                                  .toString() !=
                                                              ''
                                                          ? profileData
                                                              .data
                                                              .attendance
                                                              .workingDays
                                                              .toString()
                                                          : 'N/A',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('On time: ',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                  Consumer<ProfileProvider>(
                                                    builder: (context,
                                                        profileProvider, _) {
                                                      final profileData =
                                                          profileProvider
                                                              .userData;
                                                      return Text(
                                                        profileData != null &&
                                                                profileData
                                                                        .data
                                                                        .attendance
                                                                        .onTime
                                                                        .toString() !=
                                                                    ''
                                                            ? profileData
                                                                .data
                                                                .attendance
                                                                .onTime
                                                                .toString()
                                                            : 'N/A',
                                                        style:
                                                            GoogleFonts.mulish(
                                                                color: Colors
                                                                    .white),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Late entry: ',
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.white),
                                                  ),
                                                  Consumer<ProfileProvider>(
                                                    builder: (context,
                                                        profileProvider, _) {
                                                      final profileData =
                                                          profileProvider
                                                              .userData;
                                                      return Text(
                                                        profileData != null &&
                                                                profileData
                                                                        .data
                                                                        .attendance
                                                                        .lateTime
                                                                        .toString() !=
                                                                    ''
                                                            ? profileData
                                                                .data
                                                                .attendance
                                                                .lateTime
                                                                .toString()
                                                            : 'N/A',
                                                        style:
                                                            GoogleFonts.mulish(
                                                                color: Colors
                                                                    .white),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
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
                                          border:
                                              Border.all(color: Colors.grey),
                                          // Grey border
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded radius
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .42,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Leave',
                                                        style:
                                                            GoogleFonts.mulish(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                )),
                                            Image.asset(
                                                'assets/images/line.png'),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Total Leave: ',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                  Text(
                                                      profileData.data.leave
                                                                  .total
                                                                  .toString() !=
                                                              ''
                                                          ? profileData
                                                              .data.leave.total
                                                              .toString()
                                                          : 'N/A',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Leave Use: ',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                  Text(
                                                      profileData.data.leave
                                                                  .used
                                                                  .toString() !=
                                                              ''
                                                          ? profileData
                                                              .data.leave.used
                                                              .toString()
                                                          : 'N/A',
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Remaining: ',
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                      (profileData.data.leave
                                                                  .total -
                                                              profileData.data
                                                                  .leave.used)
                                                          .toString(),
                                                      style: GoogleFonts.mulish(
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isLocMatched) {
                          DateTime now = DateTime.now();
                          DateTime entryTime = DateFormat('hh:mm a').parse(
                              profileData.data.settings.office.startTime);
                          DateTime exitTime = DateFormat('hh:mm a')
                              .parse(profileData.data.settings.office.endTime);
                          print('==>exitTime: $exitTime');
                                // Combine the parsed times with the current date
                          DateTime combinedEntryTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            entryTime.hour,
                            entryTime.minute,
                          );
                          DateTime combinedExitTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            exitTime.hour,
                            exitTime.minute,
                          );
                          print('==>combinedExitTime: $combinedExitTime');
                          bool isAfterEntryTime =
                              now.isAfter(combinedEntryTime);
                          bool isBeforeExitTime =
                              now.isBefore(combinedExitTime);
                          print('==>isBeforeExitTime: $isBeforeExitTime');
                          if (profileData.data.attendance.checkin == 'null' &&
                              isAfterEntryTime) {
                            showLateEntryDialog();
                          } else if (profileData.data.attendance.checkout ==
                                  'null' &&
                              isBeforeExitTime) {
                            showEarlyExitDialog();
                          } else if (isBeforeExitTime) {
                            showEarlyExitDialog();
                          } else {
                            legalSubmit(context, 'On time');
                          }
                        } else {
                          legalSubmit(context, 'Submit from Outside office');
                        }
                      },
                      child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(120),
                            color: Colors.white,
                          ),
                          //square box; equal height and width so that it won't look like oval
                          child: Stack(alignment: Alignment.center, children: [
                            Image.asset(
                              'assets/images/rounded_btn.png',
                              height: 200,
                              width: 200,
                            ),
                            Positioned(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Consumer<AttendanceProvider>(
                                    builder: (context, provider, child) {
                                      return SvgPicture.asset(
                                        profileData.data.attendance.checkin ==
                                                null
                                            ? 'assets/images/checkin_btn.svg'
                                            : 'assets/images/checkout_btn.svg',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ])),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isLocMatched ? Colors.green : Colors.redAccent,
                          size: 20,
                        ),
                        Text(
                          isLocMatched
                              ? 'Location: Office Building'
                              : 'Location: Not in Office Building',
                          style: GoogleFonts.mulish(
                              fontSize:
                                  13 / MediaQuery.textScaleFactorOf(context),
                              color: isLocMatched
                                  ? Colors.green
                                  : Colors.redAccent,
                              letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    Text(
                      'Working hours : ${calculateHours(convertToMainFormat(profileData.data.attendance.checkin.toString()))}',
                      style: GoogleFonts.mulish(
                          color: int.parse(calculateHours(convertToMainFormat(
                                          profileData.data.attendance.checkin
                                              .toString()))
                                      .split('')[0]) <
                                  1
                              ? Colors.red
                              : accent
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/checkin.svg'),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check in',
                                    style: GoogleFonts.mulish(
                                        fontSize: 14 /
                                            MediaQuery.textScaleFactorOf(
                                                context),
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Consumer<ProfileProvider>(
                                    builder: (context, provider, child) {
                                      return Text(
                                          provider.userData!.data.attendance
                                                      .checkin ==
                                                  null
                                              ? '--:--'
                                              : convertTo12HourFormat(provider
                                                  .userData!
                                                  .data
                                                  .attendance
                                                  .checkin),
                                          style: GoogleFonts.mulish(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/checkout.svg'),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Check out',
                                      style: GoogleFonts.mulish(
                                          fontSize: 14 /
                                              MediaQuery.textScaleFactorOf(
                                                  context),
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold)),
                                  Consumer<ProfileProvider>(
                                    builder: (context, provider, child) {
                                      //print('<======> '+ provider.userData!.data.attendance.checkout);
                                      return Text(
                                          provider.userData!.data.attendance
                                                      .checkout ==
                                                  null
                                              ? '--:--'
                                              : convertTo12HourFormat(provider
                                                  .userData!
                                                  .data
                                                  .attendance
                                                  .checkout),
                                          style: GoogleFonts.mulish(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/total.svg'),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total hours',
                                    style: GoogleFonts.mulish(
                                        fontSize: 14 /
                                            MediaQuery.textScaleFactorOf(
                                                context),
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Consumer<AttendanceProvider>(
                                    builder: (context, provider, child) {
                                      return Text(
                                          provider.calculateTotalHours(
                                              convertToMainFormat(profileData
                                                  .data.attendance.checkin
                                                  .toString()),
                                              convertToMainFormat(profileData
                                                  .data.attendance.checkout
                                                  .toString())),
                                          style: GoogleFonts.mulish(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14));
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
              )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.green,
                  size: 30,
                ),
              ));
  }
}
