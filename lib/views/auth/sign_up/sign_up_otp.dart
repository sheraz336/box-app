import 'dart:math';

import 'package:box_delivery_app/controllers/forget_pass_controller.dart';
import 'package:box_delivery_app/controllers/signup_controller.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/views/auth/sign_in/sign_in.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/otp_controller.dart';
import '../../../controllers/verification_controller.dart';
import '../../../widgets/custom_button.dart';
import 'sign_up_success.dart';
import 'package:box_delivery_app/controllers/login_controller.dart' as loginControllers;
class OtpVerificationScreen extends StatefulWidget {


  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isLoading=false;

  void onRegister(BuildContext context, UserController authController) async {
    if(isLoading)return;
    try {
      setState((){
        isLoading=true;
      });
      final loginController = loginControllers.AuthController();
      loginController.setEmail(authController.user.email);
      loginController.setPassword(authController.user.password);

      await authController.signUp();
      await loginController.signIn();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => SignUpCompletedScreen()),
          (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    setState((){
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<UserController>(context);
    final verificationController = Provider.of<VerificationController>(context);
    print("phone num${verificationController.fullPhoneNumber}");

    return SafeArea(
        child: FirebasePhoneAuthHandler(
            phoneNumber: verificationController.fullPhoneNumber,
            signOutOnSuccessfulVerification: true,
            sendOtpOnInitialize: true,
            linkWithExistingUser: false,
            autoRetrievalTimeOutDuration: const Duration(seconds: 60),
            otpExpirationDuration: const Duration(seconds: 60),
            onCodeSent: () {
              showSnackbar(context, "Code sms sent");
            },
            onLoginSuccess: (userCredential, autoVerified) async {
              showSnackbar(context, "Phone verified successfully");
              print("phone verify success");
              print(authController.user.name);
              print(authController.user.email);
              print(authController.user.password);
              onRegister(context, authController);
            },
            onLoginFailed: (authException, stackTrace) {
              switch (authException.code) {
                case 'invalid-phone-number':
                  // invalid phone number
                  return showSnackbar(context, 'Invalid phone number!');
                case 'invalid-verification-code':
                  // invalid otp entered
                  return showSnackbar(context, 'The entered OTP is invalid!');
                // handle other error codes
                default:
                  showSnackbar(context, 'Something went wrong!');
                // handle error further if needed
              }
            },
            onError: (error, stackTrace) {},
            builder: (context, controller) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<OtpController>(
                    builder: (context, otpController, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 100),
                          Center(
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                color: Color(0xff182035),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "Enter the code from the SMS we sent to\n",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff606268),
                                    ),
                                  ),
                                  TextSpan(
                                    text: verificationController
                                        .verification.phoneNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff313646),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              "",
                              // "${otpController.secondsRemaining}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffe25e00),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 40,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  cursorColor: Color(0xffe25e00),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffe25e00), width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffe25e00), width: 2),
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    if (value.isNotEmpty && index < 5) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    otpController.setOtp(
                                        otpController.otpModel.otp + value);
                                  },
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: (){
                                controller.sendOTP();
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "I didn't receive any code. ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff606268),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "RESEND",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff9899A0),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: CustomButton(
                              isLoading:isLoading,
                              text: 'Submit',
                              onPressed: () async {
                                if (otpController.otpModel.otp.length == 6) {
                                  final verified = await controller
                                      .verifyOtp(otpController.otpModel.otp);
                                }
                                // otpController.setPhoneNumber("+1234567890");
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             SignUpCompletedScreen()));
                                // otpController.startTimer();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }));
  }
}
