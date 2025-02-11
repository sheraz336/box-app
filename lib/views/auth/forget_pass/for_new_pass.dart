import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_controller_for.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textform.dart';
import 'for_success.dart';
import '../sign_in/sign_in.dart';

class SetNewPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController1>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: const Text(
                  "Set New Password",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'New Password',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                hintText: 'Enter new password',
                onChanged: userController.updateEmail,
                errorText: userController.passwordError,
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                hintText: 'Confirm password',
                obscureText: true,
                onChanged: userController.updateEmail,
                errorText: userController.passwordError,
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Reset Password",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetSuccessScreen()));
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remembered password? ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7A848C),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle create account
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF21252C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
