import 'dart:convert';

import 'package:employe_management_system/Model/leave_apply_model.dart';
import 'package:employe_management_system/utill/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/leave_types_model.dart';

class LeaveProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Datum> _leaveTypes = [];
  List<Datum> get leaveTypes => _leaveTypes;

  Future<void> fetchLeaveTypes({required String token}) async {
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.leaveTypesData);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("res: " + response.body.toString());
        final parsedResponse = json.decode(response.body);
        final List<Datum> fetchedLeaveTypes = List<Datum>.from(parsedResponse["data"].map((x) => Datum.fromJson(x)));
        _leaveTypes = fetchedLeaveTypes;
        notifyListeners();
        _saveLeaveTypesToCache(_leaveTypes);
      } else if (response.statusCode == 422) {
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        } else if (response.statusCode == 500) {
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<void> _saveLeaveTypesToCache(List<Datum> leaveTypes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> leaveTypesJson = leaveTypes.map((leaveType) => jsonEncode(leaveType.toJson())).toList();
    await prefs.setStringList('leaveTypes', leaveTypesJson);
  }

  Future<void> getLeaveTypesFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? leaveTypesJson = prefs.getStringList('leaveTypes');
    if (leaveTypesJson != null) {
      final List<Datum> cachedLeaveTypes = leaveTypesJson.map((json) => Datum.fromJson(jsonDecode(json))).toList();
      _leaveTypes = cachedLeaveTypes;
      notifyListeners();
    }
  }

  Future<LeaveApplyModel?> applyLeave(String token, String title, String reason,
      int leaveType, String startTime, String endTime) async {
     isLoading = true;
    final url = Uri.parse(AppConstants.applyLeave);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': title,
          'reason': reason,
          'leave_type': leaveType,
          'started_at': startTime,
          'ended_at': endTime,
        }),
      );

      if (response.statusCode == 200) {
        isLoading = false;
        Get.snackbar(
          'Success',
          'Leave Applied Successfully !',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        print("res: " + response.body.toString());
        final profileData = LeaveApplyModel.fromJson(jsonDecode(response.body));
        notifyListeners();
        return profileData; // Update user data
      }
      else if (response.statusCode == 422) {
          isLoading = false;
          print("res: " + response.body.toString());
          final profileData = LeaveApplyModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        } else if (response.statusCode == 500) {
          isLoading = false;
          print("res: " + response.body.toString());
          final leaveData = LeaveApplyModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            jsonDecode(response.body.toString())["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }else{
          isLoading = false;
          print("res: " + response.body.toString());
          print("res222: " + response.statusCode.toString());
        }
        notifyListeners();
        return null; // Add a return statement
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }
}
