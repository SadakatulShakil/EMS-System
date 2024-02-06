import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AttendanceProvider with ChangeNotifier {
  String _checkInTime = '';
  String _checkOutTime = '';
  bool _resetFlag = false; // Added reset flag
  String get checkInTime => _checkInTime;
  String get checkOutTime => _checkOutTime;

  Future<void> loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkInTime = prefs.getString('checkInTime') ?? '';
    _checkOutTime = prefs.getString('checkOutTime') ?? '';
    notifyListeners();
  }

  Future<void> toggleCheckInOut() async {
    if (_checkInTime.isEmpty) {
      // Check-in
      final now = DateTime.now();
      _checkInTime = DateFormat.jm().format(now);
    } else {
      // Check-out
      final now = DateTime.now();
      _checkOutTime = DateFormat.jm().format(now);
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
}
