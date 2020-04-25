import 'dart:convert';
import 'dart:io';

import 'package:quickfix/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<bool> checkInternetConn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static void setUserSession(String user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("user", user);
  }

  static Future<User> getUserSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return User.fromjson(jsonDecode(sp.get("user")));
  }

  static void showAlert(BuildContext context, String title, String message) {}
}
