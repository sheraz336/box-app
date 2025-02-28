import 'package:box_delivery_app/controllers/login_controller.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/views/auth/sign_up/sign_up_email_verify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/signup_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textform.dart';
import '../sign_in/sign_in.dart';
import 'sign_up_verify.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final formKey = GlobalKey<FormState>();
  bool isLoading=false;

  void onRegister(BuildContext context, UserController authController) async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
      });
      final loginController = AuthController();
      loginController.setEmail(authController.user.email);
      loginController.setPassword(authController.user.password);

      await authController.signUp();
      await loginController.signIn();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => EmailVerificationScreen()),
              (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void googleSignin(BuildContext context) async {
    try {
      final success = await AuthController().signInWithGoogle();
      if (!success) return;
      Navigator.pushNamedAndRemoveUntil(
          context,
          "/"
          "home",
          (route) => false);
    } catch (e) {
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<UserController>(context);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: const Text(
                  "Register Your New Account",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Name',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              CustomTextFormField(
                maxLength: 30,
                hintText: 'Enter your name',
                onChanged: authController.updateName,
                validator: Validators.fullNameValidator,
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 2),
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
              const SizedBox(height: 2),
              CustomTextFormField(
                hintText: 'Enter email address',
                obscureText: false,
                onChanged: authController.updateEmail,
                validator: Validators.emailValidator,
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21252C),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              CustomTextFormField(
                maxLength: 16,
                hintText: 'Enter password',
                obscureText: true,
                onChanged: authController.updatePassword,
                validator: Validators.passwordValidator,
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 2),
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
              const SizedBox(height: 2),
              CustomTextFormField(
                maxLength: 16,
                hintText: 'Confirm Password',
                obscureText: true,
                onChanged: authController.updateConfirmPassword,
                validator: (txt) {
                  if (txt == null || txt.isEmpty) return "Cannot be empty";

                  if (authController.user.password !=
                      authController.user.confirmPassword)
                    return "Passwords do not match";
                  return null;
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xffBABFC5)),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Sign Up",
                isLoading:isLoading,
                onPressed: () => onRegister(context, authController),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7A848C),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
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
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xffF1F2F6),
                      thickness: 1.68,
                      endIndent: 8,
                    ),
                  ),
                  Text(
                    'or sign in with',
                    style: TextStyle(
                        color: Color(0xff7A848C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xffF1F2F6),
                      thickness: 1.68,
                      endIndent: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 160,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFCFD5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: Size(160, 56),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Google',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF21252C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ));
  }
}
