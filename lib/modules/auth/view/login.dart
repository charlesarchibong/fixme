import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/flush_bar.dart';
import '../provider/login_form_validation.dart';
import 'phone_number_verification.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneControl = new TextEditingController();
  void _loginUser() {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    if (loginForm.validate(_phoneControl.text)) {
      loginForm.setLoading();
      loginForm.loginUser(_phoneControl.text).then((user) {
        // print(user.toJson());
        if (user != null) {
          loginForm.setNotLoading();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              print(user.toJson().toString());
              print('From login');
              return PhoneNumberVerification(user: user);
            }),
          );
        } else {
          throw new Exception('Invalid phone number, please try again!');
        }
      }).catchError((error) {
        loginForm.setNotLoading();
        // print(error.toString().split(":")[1]);
        String message = error is SocketException
            ? 'No Internet connection available'
            : 'Your request can not be processed, please try again.';

        FlushBarCustomHelper.showErrorFlushbar(
          context,
          'Error',
          message,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormValidation>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: UniqueKey(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 50, 20, 0),
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
                SizedBox(height: 20.0),
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
                      keyboardType: TextInputType.phone,
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
                        hintText: "Phone Number (09033393439)",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
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
                    elevation: 3.0,
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
                      // ignore: unnecessary_statements
                      loginForm.loading ? null : _loginUser();
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
