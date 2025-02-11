import 'package:box_delivery_app/controllers/signup_controller.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/otp_controller.dart';
import '../../../controllers/verification_controller.dart';
import '../../../widgets/custom_button.dart';
import 'sign_up_success.dart';
import 'package:box_delivery_app/controllers/login_controller.dart'
    as loginControllers;
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isLoading = false;

  void onRegister(BuildContext context, UserController authController) async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
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
    setState(() {
      isLoading = false;
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
              print(authException);
              print(stackTrace);
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffe25e00),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          PinInputField(onSubmit: (code) {
                            otpController.setOtp(code);
                          }),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
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
                              isLoading: isLoading,
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

class PinInputField extends StatefulWidget {
  final int length;
  final void Function(bool)? onFocusChange;
  final void Function(String) onSubmit;

  const PinInputField({
    super.key,
    this.length = 6,
    this.onFocusChange,
    required this.onSubmit,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late final TextEditingController _pinPutController;
  late final FocusNode _pinPutFocusNode;
  late final int _length;

  Size _findContainerSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.85;

    width /= _length;

    return Size.square(width);
  }

  @override
  void initState() {
    _pinPutController = TextEditingController();
    _pinPutFocusNode = FocusNode();

    if (widget.onFocusChange != null) {
      _pinPutFocusNode.addListener(() {
        widget.onFocusChange!(_pinPutFocusNode.hasFocus);
      });
    }

    _length = widget.length;
    super.initState();
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    super.dispose();
  }

  PinTheme _getPinTheme(
    BuildContext context, {
    required Size size,
  }) {
    return PinTheme(
      height: size.height,
      width: size.width,
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE25E00), width: 2),
        borderRadius: BorderRadius.circular(7.5),
      ),
    );
  }

  static const _focusScaleFactor = 1.15;

  @override
  Widget build(BuildContext context) {
    final size = _findContainerSize(context);
    final defaultPinTheme = _getPinTheme(context, size: size);

    return SizedBox(
      height: size.height * _focusScaleFactor,
      child: Pinput(
        length: _length,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
          height: size.height * _focusScaleFactor,
          width: size.width * _focusScaleFactor,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: Color(0xFFE25E00), width: 2),
            color: Colors.white,
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        onCompleted: widget.onSubmit,
        pinAnimationType: PinAnimationType.scale,
        // submittedFieldDecoration: _pinPutDecoration,
        // selectedFieldDecoration: _pinPutDecoration,
        // followingFieldDecoration: _pinPutDecoration,
        // textStyle: const TextStyle(
        //   color: Colors.black,
        //   fontSize: 20.0,
        //   fontWeight: FontWeight.w600,
        // ),
      ),
    );
  }
}
