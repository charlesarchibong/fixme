import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/login_form_validation.dart';
import 'package:quickfix/screens/main_screen.dart';
import 'package:quickfix/util/Utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneControl = new TextEditingController();
  void _loginUser() {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    if (loginForm.validate(_phoneControl.text)) {
      loginForm.setLoading();
      loginForm.loginUser(_phoneControl.text).then((user) {
        loginForm.setNotLoading();
        print(user.toJson());
        if (user != null) {
          Utils.setUserSession(jsonEncode(user));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return MainScreen();
            }),
          );
        } else {
          throw new Exception('Invalid phone number, please try again!');
        }
      }).catchError((error) {
        loginForm.setNotLoading();
        print(error.toString().split(":")[1]);
        String message = error.toString().split(":")[1];
//        _showAlert(context, error.toString().split(":")[1]);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 5),
          ),
        );
      });
    }
  }

//  void _showAlert(BuildContext context, String message) {
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("Error"),
//              content: Text(message),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(10.0)),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text("Try again"),
//                  padding: EdgeInsets.all(10.0),
//                  textColor: Colors.white,
//                  color: Theme.of(context).accentColor,
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                )
//              ],
//            ));
//  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormValidation>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 15.0,
              ),
              child: Image.asset(
                "assets/cat.png",
                width: 200,
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    errorText: loginForm.phone
                        ? 'Phone Number field can not be empty'
                        : null,
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _phoneControl,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              height: 50.0,
              child: RaisedButton(
                child: loginForm.loading
                    ? Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text(
                        "LOGIN".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                onPressed: () {
                  _loginUser();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
