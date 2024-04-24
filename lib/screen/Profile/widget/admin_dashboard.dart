import 'package:employe_management_system/screen/Profile/widget/attendance_status.dart';
import 'package:employe_management_system/screen/Profile/widget/leave_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/profile_provider.dart';
import '../../../utill/color_resources.dart';


class AdminDashBoardScreen extends StatefulWidget {

  @override
  _AdminDashBoardScreenState createState() => _AdminDashBoardScreenState();
}

class _AdminDashBoardScreenState extends State<AdminDashBoardScreen> {

  String? token;
  String? birthDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _showDatePicker() {
    /// TODO changing the color of date picker
    DateTime currentDate = DateTime.now();
    DateTime previousDays = DateTime(1800);
    DateTime nextDays = currentDate.add(Duration(days: 1));

    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: previousDays,
        lastDate: nextDays,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  onPrimary: Colors.black,
                  onSurface: Colors.black, // default text color
                  primary: Theme.of(context).colorScheme.primary // circle color
              ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      textStyle: GoogleFonts.mulish(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                      primary: Colors.black, // color of button's letters
                      backgroundColor: Theme.of(context).colorScheme.primary, // Background color
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)))),
            ),
            child: child!,
          );
        }
    ).then((value) {
      if (value != null) {
        setState(() {
          birthDate = convertReadableDate(value.toString());
          print('===> '+birthDate.toString());
          getDashBoardData();
        });
      }
    });
  }

  Future<void> getDashBoardData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    final now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('hgvf: '+token!);
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

  String convertReadableDate(String dob) {
    DateTime doBirth = DateTime.parse(dob);

    // Create a DateFormat object to format the DateTime
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Format the DateTime to the desired format
    String formattedDOB = formatter.format(doBirth);

    return formattedDOB;
  }

  String convertMainDate(String date){
    DateTime doBirth = DateTime.parse(date);

    // Create a DateFormat object to format the DateTime
    DateFormat formatter = DateFormat('dd MMMM, yyyy, EEEE');

    // Format the DateTime to the desired format
    String formattedDate = formatter.format(doBirth);

    return formattedDate;
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final dashBoardData = profileProvider.dashBoardData;
    return Scaffold(
        backgroundColor: Color(0xFFF6F8FE),
        appBar:AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF66A690),
          title: Text('Dash-Board Report', style: GoogleFonts.mulish(),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !profileProvider.isProLoading ?SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(birthDate != null?'${convertMainDate(birthDate!)}':'${convertMainDate(DateTime.now().toString())}', style: GoogleFonts.mulish(fontSize: 22, color: textAccent, fontWeight: FontWeight.w600),),
                    GestureDetector(
                      onTap: (){
                        _showDatePicker();
                      },
                        child: Icon(Icons.calendar_month_sharp, color: textAccent, size: 28,))
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height/10 ,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AttendanceStatusPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0,right: 32),
                    child: Container(
                      height: MediaQuery.of(context).size.height/5,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Attendance Status', style: GoogleFonts.mulish(fontSize: 20, color: textAccent, fontWeight: FontWeight.w600)),
                          Text('${dashBoardData!.data.reportData.attendance}', style: GoogleFonts.mulish(fontSize: 20, color: textAccent, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16 ,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LeaveStatusPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0,right: 32, top: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height/5,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Leave Status', style: GoogleFonts.mulish(fontSize: 20, color: textAccent, fontWeight: FontWeight.w600)),
                          Text('${dashBoardData.data.reportData.attendance}', style: GoogleFonts.mulish(fontSize: 20, color: textAccent, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: Colors.green,
            size: 30,
          ),
        )
    );
  }
}

