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

import '../../../providers/profile_provider.dart';

class LeaveStatusPage extends StatefulWidget {
  @override
  _LeaveStatusPageState createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends State<LeaveStatusPage> {
  List<Datum> attendanceRecords = [];
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String convertTo12HourFormat(String dateTimeString) {
    if(dateTimeString == ''){
      return '--:--';
    }
    // Parse the date-time string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the time in 12-hour format with AM/PM
    String formattedTime = DateFormat('dd MMMM, yyyy').format(dateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final dashBoardData = profileProvider.dashBoardData;
    if(dashBoardData != null){
      return Scaffold(
        backgroundColor: Color(0xFFF6F8FE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF66A690),
          title: Text('Leave Status',style: GoogleFonts.mulish()),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: dashBoardData.data.leaves.length,
            itemBuilder: (context, index) {
              final record = dashBoardData.data.leaves[index];
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
                                    image: record.photo != null?record.photo:'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg',
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
                                Text(record.name,style: GoogleFonts.mulish(color: textAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                                Text(record.designation,style: GoogleFonts.mulish(color: Colors.grey)),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(record.status == "APPROVED"
                                      ? 'Approved': record.status == "PENDING"
                                      ? 'Pending': 'Decline',
                                    style: GoogleFonts.mulish(color: record.status == "APPROVED"
                                        ?Colors.green : record.status == "PENDING"
                                        ? Colors.blue : Colors.redAccent, fontSize: 15),)),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 8),
                          child: Row(
                            children: [
                              Text('Leave : from ',style: GoogleFonts.mulish(fontWeight: FontWeight.w500)),
                              Text(convertTo12HourFormat(record.from.toString()),style: GoogleFonts.mulish(fontWeight: FontWeight.w700, color: textAccent)),
                              Text(' to ',style: GoogleFonts.mulish(fontWeight: FontWeight.w500)),
                              Text(convertTo12HourFormat(record.to.toString()),style: GoogleFonts.mulish(fontWeight: FontWeight.w700, color: textAccent)),
                            ],
                          ),
                        ),
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
