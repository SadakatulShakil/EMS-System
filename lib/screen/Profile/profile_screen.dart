import 'package:employe_management_system/screen/Profile/update_profile.dart';
import 'package:employe_management_system/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_session_provider.dart';
import '../login/widget/main_login_widget.dart';
import '../report/report_page.dart';
class ProfileScreen extends StatefulWidget {
  bool backExits;
  ProfileScreen({Key? key, required this.backExits}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthSessionProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png',),
                  radius: 60,
                ),
              ),
              SizedBox(height: 8,),
              Align(
                alignment: Alignment.center,
                child: Text('Mr. Haasan Masud', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.grey[700]),)
              ),
              SizedBox(height: 8,),
              Align(
                  alignment: Alignment.center,
                  child: Text('Senior Software Engineer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[500]),)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(thickness: 1,),
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Department: '),
                    Flexible(child: Text('Technology', textAlign: TextAlign.end))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email: '),
                    Flexible(child: Text('haasanmanud@company.com', textAlign: TextAlign.end))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phone: '),
                    Flexible(child: Text('+8801751330394', textAlign: TextAlign.end))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Address: '),
                    Flexible(child: Text('Level 4 House, 73 Rd No 13A, Dhaka 1213', textAlign: TextAlign.end,))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(thickness: 1,),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileUpdateScreen()));
                  },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 25,),
                          SizedBox(width: 10,),
                          Text('Settings', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportPageSection()));
                  },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.report_outlined, size: 25,),
                          SizedBox(width: 10,),
                          Text('Reports', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => BarChartSample2()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.history, size: 25,),
                          SizedBox(width: 10,),
                          Text('Pending request', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.history_edu, size: 25,),
                        SizedBox(width: 10,),
                        Text('Leave History', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 25,),
                        SizedBox(width: 10,),
                        Text('Attendance History', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  sessionProvider.userToken= '';
                  await  sessionProvider.remove().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width*.5,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 25, color: Colors.red,),
                          SizedBox(width: 10,),
                          Text('Logout', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.red),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

