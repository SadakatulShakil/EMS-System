import 'dart:convert';

import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:employe_management_system/Model/leave_history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utill/app_constant.dart';

class LeaveHistoryProvider with ChangeNotifier {
  LeaveHistoryModel? _historyData;
  bool isLoading = false;

  LeaveHistoryModel? get historyData => _historyData;

  void setHistoryData(LeaveHistoryModel data) {
    _historyData = data;
    notifyListeners();
  }

  Future<LeaveHistoryModel> fetchHistory({required String token}) async {
    isLoading = true;
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.leaveHistory);
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
        final historyData = LeaveHistoryModel.fromJson(jsonDecode(response.body));
        setHistoryData(historyData);
        notifyListeners();
        return LeaveHistoryModel.fromJson(jsonDecode(response.body));// Update user data
      } else {
        if (kDebugMode) {
          print("res: " + response.statusCode.toString());
          print("res: " + response.body.toString());
          return LeaveHistoryModel.fromJson(jsonDecode(response.body));
        }
        if (response.statusCode == 422) {
          isLoading = false;
          final historyData = LeaveHistoryModel.fromJson(jsonDecode(response.body));
          Get.snackbar(
            'Warning',
            historyData.message.toString(),
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
            'Internal server issue !',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }
        return LeaveHistoryModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }
}
