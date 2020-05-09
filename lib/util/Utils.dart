import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/user.dart';
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

  static void setApiKey(String apiKey) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("apiKey", apiKey);
  }

  static Future<User> getUserSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('user') != null
        ? User.fromjson(jsonDecode(sp.get("user")))
        : null;
  }

  static Future<bool> clearUserSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove('user');
  }

  static Future<String> getApiKey() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('apiKey') != null ? sp.get("apiKey") : null;
  }

  static Future<bool> clearApiKey() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove('apiKey');
  }

  static void showAlert(BuildContext context, String title, String message) {}
}
