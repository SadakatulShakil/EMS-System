import 'package:employe_management_system/providers/auth_provider.dart';
import 'package:employe_management_system/providers/auth_session_provider.dart';
import 'package:employe_management_system/screen/home/dashboard_screen.dart';
import 'package:employe_management_system/screen/login/login_screen.dart';
import 'package:employe_management_system/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:background_fetch/background_fetch.dart';


void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthSessionProvider())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/auth': (context) => LoginScreen(),
          '/home': (context) => DashBoardScreen(),
        },
      ),
    );
  }
}
