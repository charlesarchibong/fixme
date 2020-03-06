import 'package:flutter/material.dart';

class Constants {
  static String appName = "Call A Technician (CAT)";
  static String baseUrl = "https://callatechnician.com.ng";
  static String createUserUrl = "/reg-user";
  static String loginUserUrl = "/user-login";

  //Colors for theme
//  Color(0xfffcfcff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
//  static Color lightAccent = Color(0xffFFA000);
//  static Color darkAccent = Color(0xffFFA000);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600];
  static Color lightAccent = Colors.yellow[700];
  static Color darkAccent = Colors.yellow[700];

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    backgroundColor: darkAccent,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkAccent,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}
