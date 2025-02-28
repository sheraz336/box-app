import 'package:box_delivery_app/repos/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/onboarding/onboarding_view.dart';
import 'auth/sign_up/sign_up_email_verify.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final isLoggedIn = ProfileRepository.instance.isLoggedIn();
      if (isLoggedIn) {
        final user = FirebaseAuth.instance.currentUser;
        if(user !=null && !user.emailVerified){
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => EmailVerificationScreen()));
          return;
        }
        Navigator.pushReplacementNamed(context, "/home");
      } else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAEC9DB),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/splash.jpg"), fit: BoxFit.contain)),
      ),
    );
  }
}
