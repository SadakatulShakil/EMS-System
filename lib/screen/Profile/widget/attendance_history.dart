import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:employe_management_system/providers/attendance_history_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class AttendanceHistoryPage extends StatefulWidget {
  @override
  _AttendanceHistoryPageState createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<Datum> attendanceRecords = [];
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistoryData();
  }
  Future<void> getHistoryData() async {
    final historyProvider = Provider.of<AttendanceHistoryProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    try {
      historyProvider.fetchHistory(token: token!);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      rethrow;
    }
  }

  String convertTo12HourFormat(String dateTimeString) {
    // Parse the date-time string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the time in 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }
  String convertToDateHourFormat(String dateTimeString) {
    // Parse the date-time string
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<AttendanceHistoryProvider>(context);
    return historyProvider.historyData != null?Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF66A690),
        title: Text('Attendance history'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: historyProvider.historyData!.data.length,
          itemBuilder: (context, index) {
            final record = historyProvider.historyData!.data[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(convertToDateHourFormat(record.checkin.toString())),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Checkin at: '+convertTo12HourFormat(record.checkin.toString())),
                        SizedBox(height: 8,),
                        Text('Checkout at: '+convertTo12HourFormat(record.checkout.toString())),
                      ],
                    ),
                  ),
                  trailing: record.lateReason != ''? Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Late Entry', style: TextStyle(color: Colors.white, fontSize: 12),),
                      )): Text('On time'),
                  onTap: () {
                    // Handle tapping on a record if needed
                  },
                ),
              ),
            );
          },
        ),
      ),
    ):Scaffold(
      body: Center(child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.green,
        size: 30,
      )),
    );
  }
}
