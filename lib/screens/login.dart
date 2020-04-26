import 'dart:convert';

import 'package:quickfix/providers/login_form_validation.dart';
import 'package:quickfix/screens/forget_password_page.dart';
import 'package:quickfix/screens/main_screen.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  void _loginUser() {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    if (loginForm.validate(_usernameControl.text, _passwordControl.text)) {
      if (loginForm.validateEmail(_usernameControl.text)) {
        loginForm.setLoading();
        loginForm
            .loginUser(_usernameControl.text, _passwordControl.text)
            .then((user) {
          loginForm.setNotLoading();
          print(user.toJson());
          Utils.setUserSession(jsonEncode(user));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return MainScreen();
            }),
          );
        }).catchError((error) {
          loginForm.setNotLoading();
          print(error.toString().split(":")[1]);
          _showAlert(context, error.toString().split(":")[1]);
        });
      }
    }
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(message),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Try again"),
                  padding: EdgeInsets.all(10.0),
                  textColor: Colors.white,
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormValidation>(context);
    return Padding(
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
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  errorText: loginForm.email
                      ? 'Email field can not be empty'
                      : loginForm.invalidEmail
                          ? 'Email address is invalid'
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
                  hintText: "Email",
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
                controller: _usernameControl,
              ),
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
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  errorText: loginForm.password
                      ? 'Password field can not be empty'
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
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordControl,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ForgetPassword();
                }));
              },
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MainScreen();
                    },
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
