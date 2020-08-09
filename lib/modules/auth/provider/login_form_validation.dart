import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickfix/helpers/errors.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/firebase/users.dart';
import 'package:quickfix/services/network/network_service.dart';
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
      String token = DotEnv().env[FIXME_TOKEN];
      // String tokenEncoded = base64.encode(utf8.encode(token));
      Map<String, String> headers = {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $token',
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
          throw new InvalidPhoneException(
            message: 'Invalid phone number, please try again!',
          );
        } else {
          String apiKey = response.headers.value('bearer');
          Utils.setApiKey(apiKey);
          Utils.setSecurityPinExist(response.data['sec_pin_status']);
          User user = User.fromjson(response.data);
          debugPrint(user.toJson().toString());
          await UsersService(userPhone: user.phoneNumber).updateUserDate(
            user: user,
            imageUrl: user.profilePicture,
          );
          return user;
        }
      } else {
        throw new Exception('Something went wrong, please try again!');
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(
          e.response.data,
        );
      }
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }

  Future<bool> recoverUser(String email) async {
    return true;
  }
}
