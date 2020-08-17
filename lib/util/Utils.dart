import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../modules/profile/model/user.dart';

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

  static void setSecurityPinExist(bool exist) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("exist", exist);
  }

  static void setAppAlreadyOpened(bool opened) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("opened", opened);
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
        ? User.fromjson(json.decode(sp.get("user")))
        : null;
  }

  static Future<String> getProfilePicture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('profilePicture') ?? null;
  }

  static Future<bool> getSecurityPinExist() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('exist') ?? false;
  }

  static Future<String> getSubService() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get('subService') ?? null;
  }

  static String getPicturePlaceHolder(String firstName, String lastName,
      {String initialPicture}) {
    String placeHolder =
        'https://dummyimage.com/400x400/990099/fff&text=${firstName[0]}${lastName[0]}';
    if (initialPicture == null)
      return placeHolder;
    else {
      if (initialPicture.split('/').last == 'null') {
        return placeHolder;
      } else {
        return initialPicture;
      }
    }
  }

  static String getTimeDifferenceFromTimeStamp(int dateTime) {
    return '${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(dateTime, isUtc: false))))}';
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
