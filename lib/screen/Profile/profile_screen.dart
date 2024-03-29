import 'package:employe_management_system/providers/auth_provider.dart';
import 'package:employe_management_system/providers/leave_application_provider.dart';
import 'package:employe_management_system/screen/Profile/widget/attendance_history.dart';
import 'package:employe_management_system/screen/Profile/widget/leave_applications.dart';
import 'package:employe_management_system/screen/Profile/widget/leave_history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/profile_provider.dart';
import '../Profile/update_profile.dart';
import '../login/login_screen.dart';
import '../report/report_page.dart';

class ProfileScreen extends StatefulWidget {
  final bool backExits;

  ProfileScreen({Key? key, required this.backExits}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final applicationProvider = Provider.of<LeaveApplicationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profileData = profileProvider.userData;
    return Scaffold(
      body: profileData != null
          ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileData.data.photo !=null?profileData.data.photo:'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg'),
                radius: 60,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                profileData.data.firstName != ''
                    ? '${profileData.data.firstName} ${profileData.data.lastName}'
                    : 'Mr. Haasan Masud',
                style: GoogleFonts.mulish(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                profileData.data.designation != ''
                    ? profileData.data.designation
                    : 'Senior Software Engineer',
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Department: '),
                  Flexible(
                    child: Text(
                      profileData.data.department != ''
                          ? profileData.data.department
                          : 'Technology',
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email: '),
                  Flexible(
                    child: Text(
                      profileData.data.email != ''
                          ? profileData.data.email
                          : 'haasanmanud@company.com',
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone: '),
                  Flexible(
                    child: Text(
                      profileData.data.phone != ''
                          ? profileData.data.phone
                          : '01751330394',
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address: '),
                  Flexible(
                    child: Text(
                      profileData.data.address != ''
                          ? profileData.data.address
                          : 'Dhaka, Bangladesh',
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdateScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 25),
                        SizedBox(width: 10),
                        Text(
                          'Settings',
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportPageSection(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.report_outlined, size: 25),
                        SizedBox(width: 10),
                        Text(
                          'Reports',
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: applicationProvider.leaveApplicationsData.length>0?true:false,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveApplicationsPage(applicationProvider.leaveApplicationsData, token)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.history, size: 25),
                          SizedBox(width: 10),
                          Text(
                            'Pending request',
                            style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveHistoryPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.history_edu, size: 25),
                        SizedBox(width: 10),
                        Text(
                          'Leave History',
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendanceHistoryPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 25),
                        SizedBox(width: 10),
                        Text(
                          'Attendance History',
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                String? token = sp.getString("tokenId");
                final logResponse = authProvider.logout(token: token!);
                logResponse.then((value)async{
                  if(value.status == 'SUCCESS'){
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setString('tokenId', '');
                    sp.setString('session_expiry', '');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                });

              },
              child: Container(
                width: MediaQuery.of(context).size.width * .5,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 25, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.green,
        size: 30,
      )),
    );
  }
}
