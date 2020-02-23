import 'package:flutter/foundation.dart';

class RegisterFormValidation extends ChangeNotifier {
  RegisterFormValidation() {
//    validate();
  }
  bool name = false;
  bool phoneNumber = false;
  bool email = false;
  bool password = false;
  bool invalidEmail = false;
//  bool  = false;
  bool validate(String name, String phone, String email, String password) {
    bool error = false;
    if (name.isEmpty) {
      this.name = true;
      error = true;
    } else {
      error = false;
      this.name = false;
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
