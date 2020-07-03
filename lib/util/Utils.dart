import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:quickfix/modules/profile/model/user.dart';
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

  static void setProfilePicture(String imagePath) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("profilePicture", imagePath);
  }

  static void setApiKey(String apiKey) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("apiKey", apiKey);
  }

  static void setSubService(String subService) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("subService", subService);
  }

  static Future<User> getUserSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('user') != null
        ? User.fromjson(jsonDecode(sp.get("user")))
        : null;
  }

  static Future<String> getProfilePicture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('profilePicture') ?? null;
  }

  static Future<String> getSubService() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('subService') ?? null;
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

  static String generateId(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
