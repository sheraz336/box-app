import 'package:flutter/material.dart';
import '../models/verification_model.dart';

class VerificationController with ChangeNotifier {
  VerificationModel _verification = VerificationModel();
  VerificationModel get verification => _verification;
  String get fullPhoneNumber => verification.countryCode + verification.phoneNumber;

  void updatePhoneNumber(String value) {
    _verification.phoneNumber = value;
    notifyListeners();
  }

  void updateCountryCode(String value) {
    _verification.countryCode = value;
    notifyListeners();
  }
}
