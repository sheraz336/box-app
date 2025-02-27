import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/signupcomp_controller.dart';

class SignUpCompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpController = Provider.of<SignUpController>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
          ),
      Stack(
        alignment: Alignment.center, // Center aligns everything inside
        children: [
          Container(
            height: 196.57,
            width: 245.18,
            child: Image.asset(
              'assets/signup_completed.png',
              color: const Color(0xff06a3e0),
            ),
          ),

          Center(
            child: const Icon(
              Icons.check, // White check mark
              size: 50, // Adjust size as needed
              color: Colors.white, // White color
            ),
          ),
        ],
      ),
          SizedBox(height: 50),

          Spacer(),
          Center(
            child: Text(
              'Sign Up Completed \n       Successfully',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff06a3e0)),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                text: 'Go to Home Screen',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (route) => false);
                }),
          )
        ],
      ),
    );
  }
}
