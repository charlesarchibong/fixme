import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/auth/provider/login_form_validation.dart';
import 'package:quickfix/modules/main_screen/view/no_profile_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/util/Utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneControl = new TextEditingController();
  String verificationId;
  Future<void> _sendCodeToPhoneNumber(User user) async {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authUser) {
      setState(() {
        print('phone number verifieds');
        loginForm.setNotLoading();
        Utils.setUserSession(jsonEncode(user));
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return NoProfileImage();
          }),
        );
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(authException.message),
          duration: Duration(seconds: 15),
        ),
      );
      loginForm.setNotLoading();
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Your automatic verification code has been sent to ' +
              _phoneControl.text),
          duration: Duration(seconds: 10),
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Phone number verification time out'),
          duration: Duration(seconds: 15),
        ),
      );
      loginForm.setNotLoading();
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: user.fullNumber,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _loginUser() {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    if (loginForm.validate(_phoneControl.text)) {
      loginForm.setLoading();
      loginForm.loginUser(_phoneControl.text).then((user) {
        // print(user.toJson());
        if (user != null) {
          _sendCodeToPhoneNumber(user);
        } else {
          throw new Exception('Invalid phone number, please try again!');
        }
      }).catchError((error) {
        loginForm.setNotLoading();
        // print(error.toString().split(":")[1]);
        String message = error is SocketException
            ? 'No Internet connection available'
            : 'Your request can not be processed, please try again.';
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
      key: UniqueKey(),
      child: Scaffold(
        key: _scaffoldKey,
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
