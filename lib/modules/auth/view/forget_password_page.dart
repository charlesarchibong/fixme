import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/auth/provider/login_form_validation.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _usernameControl = new TextEditingController();

  void _recoverUser() {
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    if (loginForm.validate(_usernameControl.text)) {
      loginForm.setLoading();
      loginForm.recoverUser(_usernameControl.text).then((user) {
        loginForm.setNotLoading();
      }).catchError((error) {
        loginForm.setNotLoading();
        print(error.toString().split(":")[1]);
        _showAlert(context, error.toString().split(":")[1], "Error");
      });
    }
  }

  void _showAlert(BuildContext context, String message, String title) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
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
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "Recover Password",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0.0),
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
                  height: 100,
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
                      errorText: loginForm.phone
                          ? 'Email field can not be empty'
                          : loginForm.phone ? 'Email address is invalid' : null,
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
              SizedBox(height: 50.0),
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
                          "Recover Password".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () {
                    _recoverUser();
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ));
  }
}
