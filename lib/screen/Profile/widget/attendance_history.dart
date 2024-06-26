import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:employe_management_system/providers/attendance_history_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utill/color_resources.dart';
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
      historyProvider.fetchHistory(token: token!).then((value){
        historyProvider.historyData!.data.sort((a, b) => b.checkin.compareTo(a.checkin));
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      rethrow;
    }
  }

  String convertTo12HourFormat(String dateTimeString) {
    if(dateTimeString == ''){
      return '--:--';
    }
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
    if(historyProvider.historyData != null){
      return Scaffold(
        backgroundColor: Color(0xFFF6F8FE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF66A690),
          title: Text('Attendance history',style: GoogleFonts.mulish()),
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
                    color: Color(0xFFF6F8FE),
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
                    title: Text(convertToDateHourFormat(record.checkin.toString()),style: GoogleFonts.mulish()),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Checkin at: '+convertTo12HourFormat(record.checkin.toString()),style: GoogleFonts.mulish()),
                          SizedBox(height: 8,),
                          Text('Checkout at: '+convertTo12HourFormat(record.checkout.toString()),style: GoogleFonts.mulish()),
                          SizedBox(height: 5,),
                          if(record.lateReason != '')
                          Text('Remarks: '+record.lateReason,style: GoogleFonts.mulish()),
                        ],
                      ),
                    ),
                    trailing: record.status == 0? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD7D7),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
                            child: Text('Late', style: GoogleFonts.mulish(color: Colors.red, fontSize: 12),),
                          )),
                    ): Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD7FFE0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
                            child: Text('On time',style: GoogleFonts.mulish(color: textAccent, fontSize: 12)),
                          )),
                    ),
                    onTap: () {
                      // Handle tapping on a record if needed
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    }else{
      return Scaffold(
        body: Center(child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.green,
          size: 30,
        )),
      );
    }
  }
}
