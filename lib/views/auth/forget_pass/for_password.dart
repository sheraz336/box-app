import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/widgets/custom_textform.dart';
import 'package:box_delivery_app/widgets/forget_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/forget_pass_controller.dart';

import '../../../widgets/custom_button.dart';
import 'for_otp.dart';

import '../sign_in/sign_in.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  bool isLoading = false;

  void onContinue(BuildContext context) async {
    if(isLoading)return;
    try {
      if (!formKey.currentState!.validate()) return;
      setState(() {
        isLoading=true;
      });
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showAlertDialog(context, "Success",
          "A reset password link was sent to your email", true, () {});
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          showSnackbar(context,'The email address is not valid.');;
        case 'user-not-found':
          showSnackbar(context,'No user found with this email.');
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff21252C)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: const Text(
                      'Enter your email address, we will \n                 send an OTP',
                      style: TextStyle(
                          color: Color(0xff76889A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  //onChanged: (value) => context.read<AuthController>().setEmail(value), textStyle: TextStyle(),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF21252C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    hintText: 'Enter email',
                    validator: Validators.emailValidator,
                    onChanged: (value) => email = value,
                    textStyle: TextStyle(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: 'Continue',
                    isLoading: isLoading,
                    onPressed: () => onContinue(context),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Remember password? ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7A848C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignInScreen()));
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
                  )
                ],
              )),
        ),
      ),
    );
  }
}
