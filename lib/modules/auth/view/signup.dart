import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/flush_bar.dart';
import '../../../util/Utils.dart';
import '../provider/login_form_validation.dart';
import 'security_pin.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _emailControl = new TextEditingController();

  final TextEditingController _firstNameControl = new TextEditingController();

  final TextEditingController _lastNameControl = new TextEditingController();

  void createAccount() {
    try {} catch (e) {}
    final loginForm = Provider.of<LoginFormValidation>(context, listen: false);
    loginForm.setLoading();
    loginForm.validateEmail(_emailControl.text);
    loginForm.validateLastName(_lastNameControl.text);
    loginForm.validateName(_firstNameControl.text);

    if (!loginForm.email && !loginForm.firstName && !loginForm.lastName) {
      loginForm.setLoading();
      loginForm
          .createUser(
        firstName: _firstNameControl.text,
        lastName: _lastNameControl.text,
        email: _emailControl.text,
      )
          .then((user) async {
        loginForm.setNotLoading();
        Utils.setUserSession(json.encode(user));
        Utils.setProfilePicture(user.profilePicture);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return EnterSecurityPin();
          }),
        );
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
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormValidation>(context);
    return Scaffold(
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
              Text(
                "Please Fill the following to create account",
                style: TextStyle(
                  color: Colors.black,
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
                  child: InputField(
                    loginForm: loginForm.email,
                    phoneControl: _emailControl,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    placeholder: "Enter Email",
                    label: "Email",
                  ),
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
                  child: InputField(
                    loginForm: loginForm.firstName,
                    phoneControl: _firstNameControl,
                    icon: Icons.perm_identity,
                    keyboardType: TextInputType.text,
                    placeholder: "Enter your first name",
                    label: "First Name",
                  ),
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
                  child: InputField(
                    loginForm: loginForm.lastName,
                    phoneControl: _lastNameControl,
                    icon: Icons.perm_identity,
                    keyboardType: TextInputType.text,
                    placeholder: "Enter your last name",
                    label: "Last Name",
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
                          "create account".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () {
                    // ignore: unnecessary_statements
                    loginForm.loading ? null : createAccount();
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    @required this.loginForm,
    @required this.phoneControl,
    this.errorMessage,
    @required this.icon,
    this.keyboardType,
    @required this.placeholder,
    @required this.label,
  });

  final bool loginForm;
  final TextEditingController phoneControl;
  final IconData icon;
  final String errorMessage;
  final String placeholder;
  final TextInputType keyboardType;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.none,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        errorText: loginForm ? errorMessage : null,
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
        hintText: placeholder,
        labelText: label,
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      maxLines: 1,
      controller: phoneControl,
    );
  }
}
