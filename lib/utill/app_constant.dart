import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'https://employeeapi.appswind.com/v1/';
  static const String loginUrl = '${baseUrl}auth/login';//https://hda.whosomalia.com/v1/login
  static const String logOutUrl = '${baseUrl}auth/logout';//https://hda.whosomalia.com/v1/login
  static const String profileData = '${baseUrl}auth/profile';//https://hda.whosomalia.com/v1/profile-details
  static const String updateProfileData = '${baseUrl}auth/profile';//https://hda.whosomalia.com/v1/profile-update
  //App colors
  static const Color chwColor =  Color(0xffD35520) ;

  static const Color rrtColor =  Color(0xff16A085) ;
  static const Color outreachColor =  Color(0xff32475B) ;
}