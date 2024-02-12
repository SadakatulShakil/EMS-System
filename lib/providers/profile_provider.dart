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

  ProfileModel? get userData => _userData;

  void setUserData(ProfileModel data) {
    _userData = data;
    notifyListeners();
  }

  Future<void> fetchProfile({required String token}) async {
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
        print("res: " + response.body.toString());
        final profileData = ProfileModel.fromJson(jsonDecode(response.body));
        setUserData(profileData); // Update user data
      } else {
        if (kDebugMode) {
          print("res: " + response.statusCode.toString());
          print("res: " + response.body.toString());
        }
        if (response.statusCode == 422) {
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
      if (kDebugMode) {
        print("Failed: $e");
      }
      throw Exception('Failed: $e');
    }
  }

  Future<void> updateProfile(String token, String firstName, String lastName, String phone, String address, File? photo) async {

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
      var responseJson = await response.stream.bytesToString();
      final profileData = ProfileModel.fromJson(jsonDecode(responseJson));
      setUserData(profileData); // Update user data
      // Profile updated successfully
      // You can handle success scenario here, such as showing a success message
      notifyListeners();
      print('Profile updated successfully');
    } else {
      // Failed to update profile
      // You can handle error scenario here, such as showing an error message
      print('Failed to update profile');
    }
  }

}
