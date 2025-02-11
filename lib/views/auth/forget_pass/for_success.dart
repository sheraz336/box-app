import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../sign_in/sign_in.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Container(
            height: 196.57,
            width: 245.18,
            child: Image.asset('assets/signup_completed.png'),
          ),
          SizedBox(height: 50),
          Center(
            child: Text(
              'Password Reset Successfully',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffE25E00)),
            ),
          ),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                text: 'Back to Login In',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                }),
          )
        ],
      ),
    );
  }
}
