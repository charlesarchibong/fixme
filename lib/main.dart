import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/providers/login_form_validation.dart';
import 'package:quickfix/providers/post_job_provider.dart';
import 'package:quickfix/screens/splash.dart';
import 'package:quickfix/screens/walkthrough.dart';
import 'package:quickfix/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'providers/register_form_validation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => RegisterFormValidation()),
        ChangeNotifierProvider(create: (_) => LoginFormValidation()),
        ChangeNotifierProvider(create: (_) => PostJobProvider()),
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
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home: Walkthrough(),
        );
      },
    );
  }
}
