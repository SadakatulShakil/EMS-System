import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../Leave/leave_screen.dart';
import '../Profile/profile_screen.dart';
import 'home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      LeaveScreen(backExits: false),
      ProfileScreen(false),
    ];

    // NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      if (_pageIndex != 0) {
        setState(() {
          _pageIndex = 0; // Navigate back to the home page
        });
        return false; // Do not close the app
      } else {
        return true; // Close the app
      }
    },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: accent,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: primaryColor,
                  iconSize: 25,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.white,
                  color: primaryColor,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.calendar,
                      text: 'Leave',
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _pageIndex,
                  onTabChange: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: _screens.elementAt(_pageIndex),
        ),
      ),
    );
  }
}
