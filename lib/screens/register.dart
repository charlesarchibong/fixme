import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/user.dart';
import 'package:quickfix/providers/register_form_validation.dart';
import 'package:quickfix/util/Utils.dart';

import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _phoneControl = new TextEditingController();
  void _registerUser() {
    final registerForm =
        Provider.of<RegisterFormValidation>(context, listen: false);
    bool errorValid = registerForm.validate(_firstNameController.text,
        _lastNameController.text, _phoneControl.text, _emailControl.text);
    bool validEmail = registerForm.validateEmail(_emailControl.text);
    if (!errorValid) {
      if (validEmail) {
        registerForm.setLoading();
        User user = new User.name(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phoneNumber: _phoneControl.text,
            email: _emailControl.text);
        registerForm.registerUser(user.toJson()).then((user) {
          registerForm.setNotLoading();
          print(user.toJson());
          Utils.setUserSession(jsonEncode(user));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return MainScreen();
              },
            ),
          );
        }).catchError((onError) {
//          SnackBar(content: BuildContext context, )
          // Alert(title: 'Error', description: onError.toString());
//          _showAlert(context, onError.toString().split(':')[1]);
          String message = onError.toString().split(':')[1];
          Flushbar(
            title: 'Error',
            message: message,
            duration: Duration(
              seconds: 5,
            ),
          )..show(context);
          registerForm.setNotLoading();
          print(onError);
        });
      }
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
    final registerForm = Provider.of<RegisterFormValidation>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Image.asset(
              "assets/cat.png",
              width: 200,
            ),
          ),
          SizedBox(height: 15.0),
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
                enabled: registerForm.enableForm,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  errorText: registerForm.firstName
                      ? 'First Name field cannot be empty'
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
                  hintText: "First Name",
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _firstNameController,
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
                enabled: registerForm.enableForm,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  errorText: registerForm.lastName
                      ? 'Last name field cannot be empty'
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
                  hintText: "Last Name",
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _lastNameController,
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
                enabled: registerForm.enableForm,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  errorText: registerForm.email
                      ? 'Email address field can not be empty'
                      : registerForm.invalidEmail
                          ? 'Invalid email address'
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
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _emailControl,
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
                enabled: registerForm.enableForm,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  errorText: registerForm.phoneNumber
                      ? 'Phone number can not be empty'
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
                  prefixIcon: Icon(
                    Icons.contact_phone,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                controller: _phoneControl,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 40.0),
          Container(
            height: 50.0,
            child: RaisedButton(
              elevation: 5.0,
              child: registerForm.loading
                  ? CircularProgressIndicator(backgroundColor: Colors.white)
                  : Text(
                      "Register".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              onPressed: () {
                _registerUser();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
