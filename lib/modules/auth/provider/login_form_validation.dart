import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

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
      final response = await NetworkService().post(
          url: url,
          headers: headers,
          body: body,
          contentType: ContentType.URL_ENCODED);
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        if (response.data['reqRes'] == "false") {
          throw new Exception('Invalid phone number, please try again!');
        } else {
          String apiKey = response.headers.value('bearer');
          Utils.setApiKey(apiKey);
          return new User.fromjson(response.data);
        }
      } else {
        throw new Exception('Something wnt wrong, please try again!');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> recoverUser(String email) async {
    return true;
  }
}
