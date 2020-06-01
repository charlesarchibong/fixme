import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/providers/dashboard_provider.dart';
import 'package:quickfix/providers/login_form_validation.dart';
import 'package:quickfix/providers/post_job_provider.dart';
import 'package:quickfix/providers/profile_provider.dart';
import 'package:quickfix/screens/splash.dart';
import 'package:quickfix/util/const.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => LoginFormValidation()),
        ChangeNotifierProvider(create: (_) => PostJobProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => DashBoardProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Constants.darkAccent);
    FlutterStatusbarcolor.setNavigationBarColor(Constants.darkAccent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);

    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home: SplashScreen(),
        );
      },
    );
  }
}
