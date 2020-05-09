import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quickfix/models/user.dart';
import 'package:quickfix/services/network_service.dart';
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
      Map<String, String> headers = {
        "Content-type": "application/x-www-form-urlencoded"
      };
      Map<String, String> body = {'phoneNumber': phone};
      String url = Constants.baseUrl + Constants.loginUserUrl;
      //
      final response =
          await NetworkService().post(url: url, headers: headers, body: body);
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data['reqRes'] == "false") {
          throw new Exception('Invalid phone number, please try again!');
        } else {
          // String apiKey = response.headers;
          print(response.headers);
          // Utils.setApiKey(apiKey);
          return new User.fromjson(response.data);
        }
      } else {
        throw new Exception('Something wnt wrong, please try again!');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> recoverUser(String email) async {}
}
