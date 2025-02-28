import 'dart:async';

import 'package:box_delivery_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResending = false;
  bool isVerifying = false;

  Timer? timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    onResend();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      try {
        if (seconds > 0) {
          seconds--;
          setState(() {});
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void onResend() async {
    if (seconds > 0) {
      showSnackbar(context, "Please wait till you can resend");
      return;
    }
    if (isResending) return;
    isResending = true;
    setState(() {});
    try {
      final user = await FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      showSnackbar(
          context, "Verification link sent to your email successfully");
      isResending = false;
      seconds = 60;
      setState(() {});
    } catch (e) {
      isResending = false;
      setState(() {});
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  void onContinue() async {
    if (isVerifying) return;
    isVerifying = true;
    setState(() {});
    try {
      final user = await FirebaseAuth.instance.currentUser!;
      await user.reload();
      if (!user.emailVerified) {
        showSnackbar(
            context, "Please verify email first before you can continue");
        isVerifying = false;
        setState(() {});
        return;
      }

      isVerifying = false;
      Navigator.pushNamedAndRemoveUntil(
          context, "/verification_success", (route) => false);
    } catch (e) {
      isVerifying = false;
      setState(() {});
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.email, size: 100, color: Color(0xFF06a3e0)),
              const SizedBox(height: 20),
              const Text(
                "Email Verification",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "An email has been sent with the confirmation link to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(text: 'Continue',isLoading:isVerifying, onPressed: onContinue),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onResend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: const Color(0xFF06a3e0),)
                      ),
                      elevation: 0,
                    ),
                    child: isResending
                        ? Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: const Color(0xFF06a3e0),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Text(
                            "Resend Link ${seconds > 0 ? "($seconds)" : ""}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:const Color(0xFF06a3e0),
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
