import 'package:flutter/material.dart';

class Constants {
  static String appName = "QuickFix Artisan";
  static String baseUrl = "https://manager.quickfixnaija.com.ng/";
  static String createUserUrl = "reg-user";
  static String loginUserUrl = "m-login";
  static String addSubService = "add-sub-service";

  //Colors for theme
//  Color(0xfffcfcff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
//  static Color lightAccent = Color(0xffFFA000);
//  static Color darkAccent = Color(0xffFFA000);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.red[600];
  static Color lightAccent = Colors.red;
  static Color darkAccent = Colors.red;

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.red,
    // brightness: Brightness.light,
    backgroundColor: darkAccent,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    fontFamily: 'Popins',
    cursorColor: lightAccent,
    brightness: Brightness.light,
    textSelectionColor: Colors.red,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkAccent,
    textSelectionColor: Colors.red,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    fontFamily: 'Popins',
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}
