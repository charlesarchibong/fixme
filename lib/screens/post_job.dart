import 'package:call_a_technician/providers/login_form_validation.dart';
import 'package:call_a_technician/util/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormValidation>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Constants.lightAccent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "Post Job",
              style: TextStyle(color: Colors.white),
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
                    // controller: _usernameControl,
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
                          "Add Job".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () {
                    // _recoverUser();
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ));
  }
}
