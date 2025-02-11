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
              'Sign Up Completed \n       Successfully',
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
