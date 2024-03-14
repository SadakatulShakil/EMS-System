import 'package:employe_management_system/Model/leave_application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/leave_application_provider.dart';
class LeaveApplicationsPage extends StatefulWidget {
  List<Datum> leaveApplicationsData;
  String? token;

  LeaveApplicationsPage(this.leaveApplicationsData, this.token);

  @override
  _LeaveApplicationsPageState createState() => _LeaveApplicationsPageState();
}

class _LeaveApplicationsPageState extends State<LeaveApplicationsPage> {
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicationHistoryData();
  }

  Future<void> getApplicationHistoryData() async {
    final historyProvider = Provider.of<LeaveApplicationProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    try {
      historyProvider.fetchApplications(token: token!).then((value){
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching application: $e');
      }
      rethrow;
    }
  }

  Future<void> _leaveAcceptCall(int leaveId, int statusId) async {
    final applicationProvider = Provider.of<LeaveApplicationProvider>(context, listen: false);
    print('hgvf: '+widget.token!);
    try {
      applicationProvider.updateApplication(widget.token!, leaveId, statusId).then((value){
        getApplicationHistoryData();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching application: $e');
      }
      rethrow;
    }
  }

  Future<void> _leaveRejectCall(int leaveId, int statusId) async {
    final applicationProvider = Provider.of<LeaveApplicationProvider>(context, listen: false);
    print('hgvf: '+widget.token!);
    try {
      applicationProvider.updateApplication(widget.token!, leaveId, statusId).then((value){
        getApplicationHistoryData();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching application: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationProvider = Provider.of<LeaveApplicationProvider>(context);
    return !applicationProvider.isLoading?Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFF66A690),
              title: Text('Leave history'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: applicationProvider.leaveApplicationsData.length,
                itemBuilder: (context, index) {
                  final record = applicationProvider.leaveApplicationsData[index];
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
                            Text('Applied by: ' + record.employee.toString()),
                            Text('Leave type: ' + record.type.toString()),
                            Text('Start from: ' + record.startedAt.toString()),
                            Text('Till at: ' + record.endedAt.toString()),
                            Text('Reason: ' + record.reason.toString()),
                            SizedBox(height: 8,),
                            Visibility(
                              visible: record.status == 'APPROVED' ? false : true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                GestureDetector(
                                  onTap: (){
                                    _leaveAcceptCall(record.leaveId, 2);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                            child: Text('Accept', style: GoogleFonts.mulish(color: Colors.white, fontSize: 15),)),
                                      )),
                                ),
                                  Visibility(
                                    visible: record.status == 'REJECTED' ? false : true,
                                    child: GestureDetector(
                                      onTap: () {
                                        _leaveRejectCall(record.leaveId, 1);
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('Reject', style: GoogleFonts.mulish(color: Colors.white, fontSize: 15),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                    ],),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ):Scaffold(
            body: Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.green,
        size: 30,
      ),
    ),
          );
  }
}
