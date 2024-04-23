import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:employe_management_system/providers/attendance_history_provider.dart';
import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceStatusPage extends StatefulWidget {
  @override
  _AttendanceStatusPageState createState() => _AttendanceStatusPageState();
}

class _AttendanceStatusPageState extends State<AttendanceStatusPage> {
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
          title: Text('Attendance Status',style: GoogleFonts.mulish()),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8, right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                clipBehavior: Clip.antiAlias,
                                child: FadeInImage.assetNetwork(
                                  image: 'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg',
                                  width: 40.0 * 1.5,
                                  height: 40.0 * 1.5,
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/images/shimmer.png',
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('Sadakatul Ajam Md. Shakil',style: GoogleFonts.mulish(color: textAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('Mobile App developer',style: GoogleFonts.mulish(color: Colors.grey)),
                          ],
                          ),
                          Spacer(),
                          record.lateReason != ''? Padding(
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Checkin at: '+convertTo12HourFormat(record.checkin.toString()),style: GoogleFonts.mulish(fontWeight: FontWeight.w500)),
                            SizedBox(height: 8,),
                            Text('Checkout at: '+convertTo12HourFormat(record.checkout.toString()),style: GoogleFonts.mulish(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                        child: Text('Total work hours: 9 hr 33 min',style: GoogleFonts.mulish(color: textAccent, fontWeight: FontWeight.w600)),
                      )
                    ],
                  )
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
