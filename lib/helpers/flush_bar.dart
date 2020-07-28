import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarCustomHelper {
  static void showInfoFlushbar(
      BuildContext context, String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 7),
    )..show(context);
  }

  static void showInfoFlushbarWithAction(BuildContext context, String title,
      String message, String action, Function onPressed) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      mainButton: RaisedButton(
        child: Text(
          action,
          style: TextStyle(color: Colors.blue.shade300),
        ),
        onPressed: onPressed,
      ),
      duration: Duration(seconds: 7),
    )..show(context);
  }

  static void showInfoFlushbarWithActionNot(BuildContext context, String title,
      String message, String action, Function onPressed) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      mainButton: RaisedButton(
        child: Text(
          action,
          style: TextStyle(color: Colors.blue.shade300),
        ),
        onPressed: onPressed,
      ),
      duration: Duration(seconds: 50),
    )..show(context);
  }

  static void showErrorFlushbar(
      BuildContext context, String title, String message) {
    Flushbar(
      title: title,
      flushbarPosition: FlushbarPosition.BOTTOM,
      padding: EdgeInsets.all(10),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: message,
      icon: Icon(
        Icons.cancel,
        size: 28,
        color: Colors.red.shade300,
      ),
      leftBarIndicatorColor: Colors.red.shade300,
      duration: Duration(seconds: 7),
    )..show(context);
  }

  static void showErrorFlushbarWithAction(BuildContext context, String title,
      String message, String action, Function onPressed) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      icon: Icon(
        Icons.cancel,
        size: 28,
        color: Colors.red.shade300,
      ),
      leftBarIndicatorColor: Colors.red.shade300,
      mainButton: RaisedButton(
        child: Text(
          action,
          style: TextStyle(color: Colors.red.shade300),
        ),
        onPressed: onPressed,
      ),
      duration: Duration(seconds: 7),
    )..show(context);
  }
}
