import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quickfix/models/user.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';

class LoginFormValidation extends ChangeNotifier {
//  LoginFormValidation() {}

  bool phone = false;
  bool loading = false;
  bool validate(String phone) {
    bool error = true;
    if (phone.isEmpty) {
      this.phone = true;
      error = false;
    } else {
      this.phone = false;
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

//  bool validateEmail(String email) {
//    bool emailValid = RegExp(
//            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//        .hasMatch(email);
//    if (emailValid) {
//      invalidEmail = false;
//      notifyListeners();
//      return emailValid;
//    } else {
//      invalidEmail = true;
//      notifyListeners();
//      return emailValid;
//    }
//  }

  Future<User> loginUser(String phone) async {
    try {
      bool connected = await Utils.checkInternetConn();
      if (connected) {
        Map<String, String> header = {
          "Content-type": "application/x-www-form-urlencoded"
        };
        Map<String, String> body = {'phoneNumber': phone};
        String url = Constants.baseUrl + Constants.loginUserUrl;
        final response = await http.post(url, headers: header, body: body);
        final apiReponse = jsonDecode(response.body);
        print(apiReponse);
        if (response.statusCode == 200) {
          if (apiReponse['upldRes'] == "false") {
            throw new Exception(apiReponse['errorMsg']);
          } else {
            String apiKey = response.headers['Bearer'];
            print(apiKey);
            Utils.setApiKey(apiKey);
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
