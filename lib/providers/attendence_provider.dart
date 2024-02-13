import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../Model/attendance_model.dart';
import '../utill/app_constant.dart';
import 'package:http/http.dart' as http;

class AttendanceProvider with ChangeNotifier {
  String _checkInTime = '';
  String _checkOutTime = '';
  int _action = 0;
  bool _resetFlag = false; // Added reset flag
  String get checkInTime => _checkInTime;

  String get checkOutTime => _checkOutTime;

  Future<void> loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkInTime = prefs.getString('checkInTime') ?? '';
    _checkOutTime = prefs.getString('checkOutTime') ?? '';
    notifyListeners();
  }

  Future<void> toggleCheckInOut(String? token, String lat, String lan, String ipv6, String reason) async {
    if (_checkInTime.isEmpty) {
      // Check-in
      final now = DateTime.now();
      _checkInTime = DateFormat.jm().format(now);
      String entryTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now); // Format the datetime into desired format
      _action = 1;
      updateAttendance(token!, entryTime, '', lat, lan, ipv6, reason, _action);
    } else {
      // Check-out
      final now = DateTime.now();
      _checkOutTime = DateFormat.jm().format(now);
      String exitTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      _action = 2;
      updateAttendance(token!, '', exitTime, lat, lan, ipv6, reason, _action);
    }

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('checkInTime', _checkInTime);
    prefs.setString('checkOutTime', _checkOutTime);
  }

  Future<void> autoResetData() async {
    // Reset data daily after 12:00 AM
    DateTime now = DateTime.now();
    if (now.hour >= 0 && now.hour < 12 && !_resetFlag) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('checkInTime');
      prefs.remove('checkOutTime');
      _checkInTime = '';
      _checkOutTime = '';
      _resetFlag = true;
      notifyListeners();
    }
  }

  String formatTime(String dateTimeString) {
    if (dateTimeString.isEmpty) {
      return 'N/A';
    }

    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return 'Error formatting time';
    }
  }

  String calculateTotalHours() {
    if (_checkInTime.isEmpty || _checkOutTime.isEmpty) {
      return '--:--';
    }

    try {
      final DateFormat timeFormat = DateFormat('HH:mm');
      DateTime checkIn = timeFormat.parse(_checkInTime);
      DateTime checkOut = timeFormat.parse(_checkOutTime);
      Duration duration = checkOut.difference(checkIn);

      int hours = duration.inHours;
      int minutes = (duration.inMinutes % 60);

      return '$hours:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Error calculating total hours';
    }
  }

  Future<AttendanceModel?> updateAttendance(String token, String checkIn, String checkOut,
      String request_lat, String request_long, String request_ip, String late_reason, int action) async {
    print('iiiiii: $checkIn....$checkOut');
    final url = Uri.parse(AppConstants.attendanceData);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'checkin': checkIn,
          'checkout': checkOut,
          'request_lat': request_lat,
          'request_long': request_long,
          'request_ip': request_ip,
          'late_reason': late_reason,
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        print("res: " + response.body.toString());
        final profileData = AttendanceModel.fromJson(jsonDecode(response.body));
        return profileData; // Update user data
      } else {
        if (kDebugMode) {
          print("res: " + response.statusCode.toString());
          print("res: " + response.body.toString());
        }
        if (response.statusCode == 422) {
          print("res: " + response.body.toString());
          final profileData = AttendanceModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            profileData.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        } else if (response.statusCode == 500) {
          print("res: " + response.body.toString());
          final profileData = AttendanceModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            profileData.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }else{
          print("res: " + response.body.toString());
          print("res222: " + response.statusCode.toString());
        }
        return null; // Add a return statement
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

}
