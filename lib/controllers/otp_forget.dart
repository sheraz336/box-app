import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  String otp = "";

  void updateOTP(String value) {
    otp = value;
    notifyListeners();
  }

  void verifyOTP() {
    if (otp.length == 4) {
      // Logic for verifying OTP
      debugPrint("OTP Verified: $otp");
    } else {
      debugPrint("Invalid OTP");
    }
  }

  void resendOTP() {
    // Logic to resend OTP
    debugPrint("OTP Resent");
  }
}
