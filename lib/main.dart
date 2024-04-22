import 'package:employe_management_system/providers/attendance_history_provider.dart';
import 'package:employe_management_system/providers/attendence_provider.dart';
import 'package:employe_management_system/providers/auth_provider.dart';
import 'package:employe_management_system/providers/connectivity_provider.dart';
import 'package:employe_management_system/providers/leave_application_provider.dart';
import 'package:employe_management_system/providers/leave_history_provider.dart';
import 'package:employe_management_system/providers/leave_provider.dart';
import 'package:employe_management_system/providers/profile_provider.dart';
import 'package:employe_management_system/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
 // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceHistoryProvider()),
        ChangeNotifierProvider(create: (_) => LeaveHistoryProvider()),
        ChangeNotifierProvider(create: (_) => LeaveApplicationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
        },
      ),
    );
  }
}
