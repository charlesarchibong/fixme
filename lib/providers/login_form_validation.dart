import 'dart:convert';
import 'dart:io';

import 'package:quickfix/models/user.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoginFormValidation extends ChangeNotifier {
//  LoginFormValidation() {}

  bool email = false;
  bool password = false;
  bool loading = false;
  bool invalidEmail = false;
  bool validate(String email, String passsword) {
    bool error = true;
    if (email.isEmpty) {
      this.email = true;
      error = false;
    } else {
      this.email = false;
      error = true;
    }
    if (passsword.isEmpty) {
      this.password = true;
      error = false;
    } else {
      this.password = false;
      error = true;
    }
    notifyListeners();
    return error;
  }

  setLoading() {
    this.loading = true;
    notifyListeners();
  }

  setNotLoading() {
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

  Future<User> loginUser(String email, String password) async {
    try {
      bool connected = await Utils.checkInternetConn();
      if (connected) {
        Map<String, String> header = {
          "Content-type": "application/x-www-form-urlencoded"
        };
        Map<String, String> body = {'email': email, 'password': password};
        String url = Constants.baseUrl + Constants.loginUserUrl;
        final response = await http.post(url, headers: header, body: body);
        final apiReponse = jsonDecode(response.body);
        print(apiReponse);
        if (response.statusCode == 200) {
          if (apiReponse['upldRes'] == "false") {
            throw new Exception(apiReponse['errorMsg']);
          } else {
            return new User.fromjson(apiReponse);
          }
        } else {
          throw new Exception('Something wnt wrong, please try again!');
        }
      } else {
        throw new SocketException('No internet connection');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> recoverUser(String email) async {}
}
