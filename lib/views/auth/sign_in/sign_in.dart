import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/login_controller.dart';
import '../../../widgets/custom_textform.dart';
import '../forget_pass/for_password.dart';
import '../sign_up/sign_up_register.dart';

class SignInScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  void signIn(AuthController authController, BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) return;

      await authController.signIn();
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void googleSignin(AuthController authController, BuildContext context) async {
    try {
      final success = await authController.signInWithGoogle();
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

  // void listen() async {
  //   FirebaseFirestore.instance
  //       .collection("test")
  //       .snapshots(includeMetadataChanges: true)
  //       .listen((snapshot) {
  //
  //     final docs = snapshot.docChanges;
  //     print("[${snapshot.metadata.isFromCache} ${snapshot.metadata.hasPendingWrites}] Document Changes received :${docs.length}");
  //     for (var doc in docs) {
  //       print("Data ${doc.doc.id}: ${doc.doc.data()}");
  //     }
  //   });
  // }
  //
  // int number = 0;
  //
  // void disconnect() async {
  //   print("Dis-Connecting.....");
  //   await FirebaseFirestore.instance.disableNetwork();
  //   print("Dis-Connected.....");
  // }
  //
  // void connect() async {
  //   print("Connecting.....");
  //   await FirebaseFirestore.instance.enableNetwork();
  //   print("Connected.....");
  // }
  //
  // void setCountValue() async {
  //   try {
  //     print("Updating........");
  //     await FirebaseFirestore.instance
  //         .doc("test/test1")
  //         .update({"num": number});
  //     print("Count value updated to $number.....");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 34),
              //   TextField(
              //     onChanged: (text) => number = int.parse(text),
              //   ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child:   Row(
              //     children: [
              //       OutlinedButton(onPressed: listen, child: Text("Listen")),
              //       OutlinedButton(onPressed: connect, child: Text("Connect")),
              //       OutlinedButton(
              //           onPressed: disconnect, child: Text("Disconnect")),
              //       OutlinedButton(
              //           onPressed: setCountValue, child: Text("Update")),
              //     ],
              //   ),
              // ),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21252C),
                  ),
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Email Address / User Name',
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
                  hintText: 'Enter email address',
                  onChanged: authController.setEmail,
                  validator: Validators.emailValidator,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffBABFC5)),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: 'Enter password',
                  obscureText: true,
                  onChanged: authController.setPassword,
                  // validator: Validators.passwordValidator,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xffBABFC5)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordView()));
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF21252C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                CustomButton(
                    text: 'Sign In',
                    isLoading: authController.isSigningIn,
                    onPressed: () => signIn(authController, context)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpView()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7A848C),
                        ),
                      ),
                      const Text(
                        ' Create Account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF21252C),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // Left Divider
                    Expanded(
                      child: Divider(
                        color: Color(0xffF1F2F6), // Adjust opacity
                        thickness: 1.68,
                        endIndent: 8, // Gap between divider and text
                      ),
                    ),
                    // Center Text
                    Text(
                      'or sign in with',
                      style: TextStyle(
                          color: Color(0xff7A848C), // Adjust opacity
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    // Right Divider
                    Expanded(
                      child: Divider(
                        color: Color(0xffF1F2F6), // Adjust opacity
                        thickness: 1.68,
                        endIndent: 8, // Gap between divider and text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 160,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFCFD5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: Size(160, 56),
                    ),
                    onPressed: () => googleSignin(authController, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google.png', // Add a Google logo asset
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
              ],
            )),
      ),
    );
  }
}
