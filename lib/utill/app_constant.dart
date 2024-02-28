import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'https://employeeapi.appswind.com/v1/';
  static const String loginUrl = '${baseUrl}auth/login';//https://hda.whosomalia.com/v1/login
  static const String logOutUrl = '${baseUrl}auth/logout';//https://hda.whosomalia.com/v1/login
  static const String profileData = '${baseUrl}auth/profile';//https://hda.whosomalia.com/v1/profile-details
  static const String updateProfileData = '${baseUrl}auth/profile';//https://hda.whosomalia.com/v1/profile-update
  static const String checkInData = '${baseUrl}attendance/checkin';//https://hda.whosomalia.com/v1/profile-update
  static const String checkOutData = '${baseUrl}attendance/checkout';//https://hda.whosomalia.com/v1/profile-update
  static const String leaveTypesData = '${baseUrl}leave/types';//https://hda.whosomalia.com/v1/profile-update
  static const String applyLeave = '${baseUrl}leave/apply';//https://hda.whosomalia.com/v1/profile-update
  static const String attendanceHistory = '${baseUrl}attendance';//https://hda.whosomalia.com/v1/profile-update
  static const String leaveHistory = '${baseUrl}leave';//https://hda.whosomalia.com/v1/profile-update
  static const String leaveApplications = '${baseUrl}leave/applications';//https://hda.whosomalia.com/v1/profile-update
  static const String updateLeaveApplications = '${baseUrl}leave/approved';//https://hda.whosomalia.com/v1/profile-update
  //App colors
  static const Color chwColor =  Color(0xffD35520) ;

  static const Color rrtColor =  Color(0xff16A085) ;
  static const Color outreachColor =  Color(0xff32475B) ;
}