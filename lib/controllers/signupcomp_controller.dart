import 'package:flutter/material.dart';
import '../models/singup_comp.dart';


class SignUpController with ChangeNotifier {
  SignUpModel _signUpModel = SignUpModel(isSignUpCompleted: false);

  SignUpModel get signUpModel => _signUpModel;

  void completeSignUp() {
    _signUpModel.isSignUpCompleted = true;
    notifyListeners();
  }
}