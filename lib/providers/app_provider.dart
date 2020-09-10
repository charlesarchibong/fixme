import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickfix/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    checkTheme();
    checkUserRole();
  }

  ThemeData theme = Constants.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String userRole = "user";
  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("theme", c).then((val) {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor:
              c == "dark" ? Constants.darkPrimary : Constants.darkPrimary,
          statusBarIconBrightness:
              c == "dark" ? Brightness.light : Brightness.light,
        ));
      });
    });
    notifyListeners();
  }

  void setUserRole(String role) {
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString("user_role", role);
    });

    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  String getUserRole() {
    return userRole;
  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData t;
    String r =
        prefs.getString("theme") == null ? "light" : prefs.getString("theme");

    if (r == "light") {
      t = Constants.lightTheme;
      setTheme(Constants.lightTheme, "light");
    } else {
      t = Constants.darkTheme;
      setTheme(Constants.darkTheme, "dark");
    }

    return t;
  }

  Future<String> checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String r = prefs.getString("user_role") == null
        ? "user"
        : prefs.getString("user_role");
    setUserRole(r);
    return r;
  }
}
