import 'dart:convert';
import 'dart:io';

import 'package:call_a_technician/models/user.dart';
import 'package:call_a_technician/util/Utils.dart';
import 'package:call_a_technician/util/const.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RegisterFormValidation extends ChangeNotifier {
  RegisterFormValidation() {
//    validate();
  }

  bool loading = false;
  bool firstName = false;
  bool phoneNumber = false;
  bool lastName = false;
  bool email = false;
  bool password = false;
  bool invalidEmail = false;
  bool enableForm = true;

  void disbledForm() {
    this.enableForm = false;
    notifyListeners();
  }

  void enabledForm() {
    this.enableForm = true;
    notifyListeners();
  }

//  bool  = false;
  bool validate(String firstName, String lastName, String phone, String email,
      String password) {
    bool error = false;
    if (firstName.isEmpty) {
      this.firstName = true;
      error = true;
    } else {
      error = false;
      this.firstName = false;
    }
    if (lastName.isEmpty) {
      this.lastName = true;
      error = true;
    } else {
      error = false;
      this.lastName = false;
    }
    if (phone.isEmpty) {
      this.phoneNumber = true;
      error = true;
    } else {
      this.phoneNumber = false;
      error = false;
    }
    if (email.isEmpty) {
      this.email = true;
      error = true;
    } else {
      this.email = false;
      error = false;
    }
    if (password.isEmpty) {
      this.password = true;
      error = true;
    } else {
      this.password = false;
      error = false;
    }
    notifyListeners();
    return error;
  }

  setLoading() {
    this.disbledForm();
    this.loading = true;
    notifyListeners();
  }

  setNotLoading() {
    this.enabledForm();
    this.loading = false;
    notifyListeners();
  }

  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      invalidEmail = false;
      notifyListeners();
      return emailValid;
    } else {
      invalidEmail = true;
      notifyListeners();
      return emailValid;
    }
  }

  Future<User> registerUser(Map<String, dynamic> user) async {
    try {
      bool connected = await Utils.checkInternetConn();
      if (connected) {
        if (connected) {
          String url = Constants.baseUrl + Constants.createUserUrl;
          Map<String, String> headers = {
            "Content-type": "application/x-www-form-urlencoded"
          };
          final response = await http.post(url, headers: headers, body: user);
          print(response.body);
          if (response.statusCode == 200) {
            var json = jsonDecode(response.body);
            if (json["upldRes"] == "true") {
              return new User.fromjson(json);
            } else {
              throw new Exception("incorrect email");
            }
          } else
            throw new Exception('Something went wrong, please try again');
        }
      } else {
        throw new SocketException('No internet connection');
      }
    } catch (e) {
      throw e;
    }
  }
}
