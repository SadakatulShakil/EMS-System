import 'dart:convert';

import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utill/app_constant.dart';

class AttendanceHistoryProvider with ChangeNotifier {
  AttendanceHistoryModel? _historyData;
  bool isLoading = false;

  AttendanceHistoryModel? get historyData => _historyData;

  void setHistoryData(AttendanceHistoryModel data) {
    _historyData = data;
    notifyListeners();
  }

  Future<AttendanceHistoryModel> fetchHistory({required String token}) async {
    isLoading = true;
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.attendanceHistory);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        isLoading = false;
        print("res: " + response.body.toString());
        final historyData = AttendanceHistoryModel.fromJson(jsonDecode(response.body));
        historyData.data.sort((a, b) => b.checkin.compareTo(a.checkin));
        setHistoryData(historyData);
        notifyListeners();
        return AttendanceHistoryModel.fromJson(jsonDecode(response.body));// Update user data
      } else if (response.statusCode == 422) {
          isLoading = false;
          final historyData = AttendanceHistoryModel.fromJson(jsonDecode(response.body));
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
        return AttendanceHistoryModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }
}
