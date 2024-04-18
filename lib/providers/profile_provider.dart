import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Model/profile_model.dart';
import '../utill/app_constant.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _userData;
  bool isLoading = false;
  bool get isProLoading => isLoading;

  void loader (bool value){
    isLoading = value;
    notifyListeners();
  }

  ProfileModel? get userData => _userData;

  void setUserData(ProfileModel data) {
    _userData = data;
    notifyListeners();
  }

  void updateCheckInData(String checkInTime) {
    // Update the check-in data in the profile data
    if (_userData != null) {
      userData?.data.attendance.checkin = checkInTime;
      notifyListeners();
    }
    // Notify listeners that the data has changed
    notifyListeners();
  }

  void updateCheckOutData(String checkOutTime) {
    // Update the check-in data in the profile data
    if (_userData != null) {
      _userData!.data.attendance.checkout = checkOutTime;
      notifyListeners();
    }
    // Notify listeners that the data has changed
    notifyListeners();
  }

  Future<void> fetchProfile({required String token}) async {
    loader(true);
    print('iiiiii:' + token);
    final url = Uri.parse(AppConstants.profileData);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        loader(false);
        print("res: " + response.body.toString());
        final profileData = ProfileModel.fromJson(jsonDecode(response.body));
        setUserData(profileData);
        notifyListeners();// Update user data
      } else {
        if (kDebugMode) {
          print("res: " + response.statusCode.toString());
          print("res: " + response.body.toString());
        }
        if (response.statusCode == 422) {
          loader(false);
          String responseData = response.body.toString();
          Get.snackbar(
            'Warning',
            responseData[0].toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        } else if (response.statusCode == 500) {
          loader(false);
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
      }
    } catch (e) {
      loader(false);
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<void> updateProfile(String token, String firstName, String lastName, String phone, String address, File? photo) async {
    loader(true);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(AppConstants.updateProfileData));
    request.headers.addAll(headers);

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['phone'] = phone;
    request.fields['address'] =address;

    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', photo.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      loader(false);
      var responseJson = await response.stream.bytesToString();
      final profileData = ProfileModel.fromJson(jsonDecode(responseJson));
      setUserData(profileData); // Update user data
      // Profile updated successfully
      // You can handle success scenario here, such as showing a success message
      notifyListeners();
      print('Profile updated successfully');
    } else {
      loader(false);
      if (kDebugMode) {
        print("res: " + response.statusCode.toString());
      }
      if (response.statusCode == 422) {
        loader(false);
        var responseJson = await response.stream.bytesToString();
        final profileData = ProfileModel.fromJson(jsonDecode(responseJson));
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
        loader(false);
        var responseJson = await response.stream.bytesToString();
        final profileData = ProfileModel.fromJson(jsonDecode(responseJson));
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
        loader(false);
        print("res222: " + response.statusCode.toString());
      }
      notifyListeners();
      return null; // Add a return statement
    }
  }

}
