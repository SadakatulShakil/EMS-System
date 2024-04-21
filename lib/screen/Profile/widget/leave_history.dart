import 'package:employe_management_system/Model/attendance_history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/leave_history_provider.dart';
class LeaveHistoryPage extends StatefulWidget {
  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  List<Datum> attendanceRecords = [];
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistoryData();
  }
  Future<void> getHistoryData() async {
    final historyProvider = Provider.of<LeaveHistoryProvider>(context, listen: false);
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
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<LeaveHistoryProvider>(context);
    return historyProvider.historyData != null?Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF66A690),
        title: Text('Leave history',style: GoogleFonts.mulish()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: historyProvider.historyData!.data.details.length,
          itemBuilder: (context, index) {
            final record = historyProvider.historyData!.data.details[index];
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Leave type: ' + record.type.toString(),style: GoogleFonts.mulish()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                      Text('Start from: ' + record.startedAt.toString(),style: GoogleFonts.mulish()),
                      Text('Till at: ' + record.endedAt.toString(),style: GoogleFonts.mulish()),
                      Text('Reason: ' + record.reason.toString(),style: GoogleFonts.mulish()),
                      SizedBox(height: 5,),
                    ],
                  ),
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
