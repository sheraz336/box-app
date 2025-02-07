import 'package:flutter/material.dart';
import '../models/for_otp.dart';
import '../models/otp_model.dart';

class OTPController with ChangeNotifier {
  OTPModel _otp = OTPModel(email: '', otp: '');
  String otp = "";void updateOtp(String value) {
    otp = value;
    notifyListeners();
  }


  void setOTP(String email, String otp) {
    _otp = OTPModel(email: email, otp: otp);
    notifyListeners();
  }

}