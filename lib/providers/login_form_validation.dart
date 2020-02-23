import 'package:flutter/foundation.dart';

class LoginFormValidation extends ChangeNotifier {
//  LoginFormValidation() {}

  bool email = false;
  bool password = false;
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
}
