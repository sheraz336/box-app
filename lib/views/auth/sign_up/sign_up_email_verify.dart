import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/verification_success", (route) => false);
                    }),
              ),
             ],
          ),
        ),
      ),
    );
  }
}
