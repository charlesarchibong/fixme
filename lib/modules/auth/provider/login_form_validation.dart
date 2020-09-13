import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/util/const.dart';

import '../../../services/firebase/users.dart';
import '../../../services/network/network_service.dart';
import '../../../util/Utils.dart';
import '../../../util/content_type.dart';
import '../../profile/model/user.dart';

class LoginFormValidation extends ChangeNotifier {
//  LoginFormValidation() {}

  bool phone = false;
  bool firstName = false;
  bool lastName = false;
  bool email = false;

  bool loading = false;
  String res = "true";

  String phoneNumber;

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

  // validate for first name
  bool validateName(String phone) {
    bool error = true;
    if (phone.isEmpty) {
      this.firstName = true;
      error = false;
    } else {
      this.firstName = false;
      error = true;
    }
    notifyListeners();
    return error;
  }

  //validate for last name
  bool validateLastName(String phone) {
    bool error = true;
    if (phone.isEmpty) {
      this.lastName = true;
      error = false;
    } else {
      this.lastName = false;
      error = true;
    }
    notifyListeners();
    return error;
  }

  //validate for email
  bool validateEmail(String phone) {
    bool error = true;
    if (phone.isEmpty) {
      this.email = true;
      error = false;
    } else {
      this.email = false;
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

  Future loginUser(String phone) async {
    try {
      phoneNumber = phone;
      String token =
          'FIXME_1U90P3444ANdroidAPP4HUisallOkayBY_FIXME_APP_UIONSISJGJANKKI3445fv';
      // String tokenEncoded = base64.encode(utf8.encode(token));
      Map<String, String> headers = {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $token',
      };
      Map<String, String> body = {'phoneNumber': phone};
      String url = "https://manager.fixme.ng/m-login";

      final response = await NetworkService().post(
          url: url,
          headers: headers,
          body: body,
          contentType: ContentType.URL_ENCODED);
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data['reqRes']);

        if (response.data['reqRes'] == "false") {
          print("i got here oooo");
          res = response.data['reqRes'];
          return response.data;
          // throw new Exception('Invalid phone number, please try again!');

        } else {
          String apiKey = response.headers.value('bearer');
          Utils.setApiKey(apiKey);

          Utils.setSecurityPinExist(response.data['sec_pin_status']);
          User user = User.fromjson(response.data);
          Utils.setUserRole(user.userRole);
          Logger().i(user.userRole);
          // debugPrint(user.toJson().toString());
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

  Future<User> createUser({
    String firstName,
    String lastName,
    String email,
  }) async {
    try {
      String token = DotEnv().env[FIXME_TOKEN];
      // String tokenEncoded = base64.encode(utf8.encode(token));
      Map<String, String> headers = {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $token',
      };
      Map<String, String> body = {
        'mobile': phoneNumber,
        'email': email,
        'firstName': firstName,
        'lastName': lastName
      };
      String url = "https://manager.fixme.ng/create-user";

      final response = await NetworkService().post(
          url: url,
          headers: headers,
          body: body,
          contentType: ContentType.URL_ENCODED);
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data['reqRes'] == "false") {
          print("i got here oooo");
          res = response.data['reqRes'];

          throw new Exception('Invalid phone number, please try again!');
        } else {
          String apiKey = response.headers.value('bearer');
          Utils.setApiKey(apiKey);
          Utils.setSecurityPinExist(response.data['sec_pin_status']);
          User user = User.fromjson(response.data);
          // debugPrint(user.toJson().toString());
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
