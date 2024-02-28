import 'dart:convert';
import 'package:employe_management_system/Model/leave_application.dart';
import 'package:employe_management_system/Model/update_application_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utill/app_constant.dart';

class LeaveApplicationProvider with ChangeNotifier {
  LeaveApplicationsModel? _applicationsData;
  UpdateApplicationModel? _updateApplicationsData;
  List<Datum> leaveApplicationsData = [];
  dynamic status = '0';
  bool isLoading = false;
  bool isApiCall = false;

  LeaveApplicationsModel? get historyData => _applicationsData;
  UpdateApplicationModel? get updateHistoryData => _updateApplicationsData;

  void setApplicationsData(LeaveApplicationsModel data) {
    _applicationsData = data;
    notifyListeners();
  }
  void setUpdateApplicationsData(UpdateApplicationModel data) {
    _updateApplicationsData = data;
    notifyListeners();
  }


  Future<LeaveApplicationsModel> fetchApplications({required String token}) async {
    isLoading = true;
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.leaveApplications);
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
        final historyData = LeaveApplicationsModel.fromJson(jsonDecode(response.body));
        setApplicationsData(historyData);
        leaveApplicationsData = historyData.data;
        print('ddddd: '+ leaveApplicationsData.length.toString());
        notifyListeners();
        return LeaveApplicationsModel.fromJson(jsonDecode(response.body));// Update user data
      } else {
        if (kDebugMode) {
          print("res: " + response.statusCode.toString());
          print("res: " + response.body.toString());
          return LeaveApplicationsModel.fromJson(jsonDecode(response.body));
        }
        if (response.statusCode == 422) {
          isLoading = false;
          final historyData = LeaveApplicationsModel.fromJson(jsonDecode(response.body));
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
        return LeaveApplicationsModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<UpdateApplicationModel> updateApplication(String token, int leaveId, int statusId) async {
    isLoading = true;

    final url = Uri.parse(AppConstants.updateLeaveApplications);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'leave_id': leaveId,
          'status': statusId,
        }),
      );
    print('jjjj: '+ response.body);
    print('kkk: '+ response.statusCode.toString());
      if (response.statusCode == 200) {
        // If response is successful
        isLoading = false;
        final decodedBody = jsonDecode(response.body);
        final historyData = UpdateApplicationModel.fromJson(decodedBody);

        // Notify user and return response
        status = historyData.data.status.toString(); // Convert to String
        print('Status: $status');
        if (status == '1' || status == '2') {
          Get.snackbar(
            'Success',
            'Application updated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }
        notifyListeners();
        return historyData;
      } else {
        // Handle non-200 status codes
        print("Received status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update application. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions
      isLoading = false;
      print('Error occurred: $e');
      throw Exception('Failed to submit: $e');
    }
  }
}
