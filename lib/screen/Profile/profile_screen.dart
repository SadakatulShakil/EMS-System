import 'package:employe_management_system/providers/auth_provider.dart';
import 'package:employe_management_system/providers/leave_application_provider.dart';
import 'package:employe_management_system/screen/Profile/widget/admin_dashboard.dart';
import 'package:employe_management_system/screen/Profile/widget/attendance_history.dart';
import 'package:employe_management_system/screen/Profile/widget/change_password.dart';
import 'package:employe_management_system/screen/Profile/widget/leave_applications.dart';
import 'package:employe_management_system/screen/Profile/widget/leave_history.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/profile_provider.dart';
import '../../utill/color_resources.dart';
import '../Profile/update_profile.dart';
import '../login/login_screen.dart';
import '../report/report_page.dart';

class ProfileScreen extends StatefulWidget {
  bool isBackExit;
  ProfileScreen(this.isBackExit);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? token;
  bool loggingOut = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicationHistoryData();
    getDashBoardData();
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

  Future<void> getDashBoardData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    final now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('hgvf: '+formattedDate!);
    try {
      profileProvider.fetchDashBoard(token: token!, date: formattedDate).then((value){
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
    final dashBoardData = profileProvider.dashBoardData;
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FE),
      appBar: widget.isBackExit?AppBar(
      elevation: 0,
      backgroundColor: Color(0xFF66A690),
      title: Text('Profile',style: GoogleFonts.mulish()),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ):null,
      body: (!loggingOut || !profileProvider.isProLoading) ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileData!.data.photo !=null?profileData.data.photo:'https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg'),
                radius: 60,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                profileData.data.firstName != null
                    ? '${profileData.data.firstName} ${profileData.data.lastName}'
                    : '',textAlign: TextAlign.center,
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
                profileData.data.designation != null
                    ? profileData.data.designation
                    : '',
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
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Department: ', style: GoogleFonts.mulish(fontSize: 16),),
                  Flexible(
                    child: Text(
                      profileData.data.department != null
                          ? profileData.data.department
                          : '',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.mulish(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email: ', style: GoogleFonts.mulish(fontSize: 16),),
                  Flexible(
                    child: Text(
                      profileData.data.email != null
                          ? profileData.data.email
                          : '',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.mulish(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone: ', style: GoogleFonts.mulish(fontSize: 16),),
                  Flexible(
                    child: Text(
                      profileData.data.phone != null
                          ? profileData.data.phone
                          : '',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.mulish(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address: ', style: GoogleFonts.mulish(fontSize: 16),),
                  Flexible(
                    child: Text(
                      profileData.data.address != null
                          ? profileData.data.address
                          : '',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.mulish(fontSize: 16),
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
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdateScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings, size: 25, color: accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                thickness: 1,
                height: 2,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.lock, size: 25, color: accent,),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Change password',
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                thickness: 1,
                height: 2,
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => ReportPageSection(),
            //       ),
            //     );
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 8.0, right: 8),
            //     child: Card(
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           children: [
            //             Icon(Icons.report_outlined, size: 25),
            //             SizedBox(width: 10),
            //             Text(
            //               'Reports',
            //               style: GoogleFonts.mulish(
            //                 fontWeight: FontWeight.w400,
            //                 fontSize: 18,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminDashBoardScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.analytics_outlined, size: 25, color: accent,),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Dashboard',
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                thickness: 1,
                height: 2,
              ),
            ),
            Visibility(
              visible: applicationProvider.leaveApplicationsData.length > 0?true:false,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      LeaveApplicationsPage(applicationProvider.leaveApplicationsData, token)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.touch_app, size: 25, color: accent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pending request',
                            style: GoogleFonts.mulish(
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: applicationProvider.leaveApplicationsData.length > 0?true:false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  thickness: 1,
                  height: 2,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveHistoryPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.history_edu, size: 25, color: accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Leave History',
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                thickness: 1,
                height: 2,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendanceHistoryPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.history, size: 25, color: accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Attendance History',
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                thickness: 1,
                height: 2,
              ),
            ),

            SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                setState(() {
                  loggingOut = true;
                });
                SharedPreferences sp = await SharedPreferences.getInstance();
                String? token = sp.getString("tokenId");
                final logResponse = authProvider.logout(token: token!);
                logResponse.then((value)async{
                  if(value.status == 'SUCCESS'){
                    loggingOut = false;
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setString('tokenId', '');
                    sp.setString('session_expiry', '');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                          (route) => false, // Removes all routes from the stack
                    );
                  }else{
                    loggingOut = false;
                  }
                });

              },
              child: Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white,),
                    SizedBox(width: 20,),
                    Text(
                      'Logout',
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
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
