import 'package:flutter/material.dart';

import '../models/forget_passw_1.dart';


class AuthController extends ChangeNotifier {
  final ForgetPassModel _model = ForgetPassModel();

  String get email => _model.email;
  String get otp => _model.otp;
  bool get isLoading => _model.isLoading;

  void setEmail(String value) {
    _model.setEmail(value);
    notifyListeners();
  }

  void setOTP(String value) {
    _model.setOTP(value);
    notifyListeners();
  }

  Future<void> sendResetEmail() async {
    _model.setLoading(true);
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _model.setLoading(false);
    notifyListeners();
  }

  Future<void> verifyOTP() async {
    _model.setLoading(true);
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _model.setLoading(false);
    notifyListeners();
  }
}