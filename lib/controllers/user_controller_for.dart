import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserController1 with ChangeNotifier {
  UserModel _user = UserModel(email: '', password: '');
  String? emailError;
  String? passwordError;
  UserModel get user => _user;

  void setUser(String email, String password) {
    _user = UserModel(email: email, password: password);
    notifyListeners();
  } void updateEmail(String value) {
    _user.email = value;
    emailError = value.isEmpty ? "Email can't be empty" : null;
    notifyListeners();
  }

  void updatePassword(String value) {
    _user.password = value;
    passwordError = value.isEmpty ? "Password can't be empty" : null;
    notifyListeners();
  }

}