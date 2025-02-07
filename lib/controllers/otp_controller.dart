import 'dart:async'; // Import Timer package
import 'package:flutter/material.dart';
import '../models/otp_model.dart';
import '../views/auth/sign_up/sign_up_success.dart';


class OtpController with ChangeNotifier {
  OtpModel _otpModel = OtpModel(otp: '', phoneNumber: '+8801774280874');
  int secondsRemaining = 30;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    secondsRemaining = 30;
    notifyListeners();

    _timer = Timer.periodic(Duration(microseconds: 10), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  OtpModel get otpModel => _otpModel;

  void setOtp(String otp) {
    _otpModel.otp = otp;
    notifyListeners();
  }

  String get phoneNumber => _otpModel.phoneNumber;

  void setPhoneNumber(String number) {
    _otpModel.phoneNumber = number;
    notifyListeners();
  }

  void verifyOtp(BuildContext context) {
    if (_otpModel.otp.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpCompletedScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
