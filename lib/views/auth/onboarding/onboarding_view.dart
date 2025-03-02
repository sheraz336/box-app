import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:box_delivery_app/widgets/page_indicator.dart';
import '../../../controllers/onboarding_provider.dart';
import '../sign_in/sign_in.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  static final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/onboarding.png',
      'title': 'Organise Your\nStorage',
      'description':
      'Effortlessly manage your boxes, items, and storage locations all in one place. Stay organised like never before!',
    },
    {
      'image': 'assets/onboarding2.png',
      'title': 'Track Every Item',
      'description':
      'Add, categorize, and secure your items with ease. No more losing track of what\'s stored where!',
    },
    {
      'image': 'assets/onboarding3.png',
      'title': 'Secure and Accessible',
      'description':
      'Enjoy secure access to your stored items anytime, anywhere. Simple tracking ensures your items are always just where you need them.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Scaffold(
        body: Consumer<OnboardingProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                PageView.builder(
                  controller: provider.pageController,
                  onPageChanged: provider.setPage,
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return _OnboardingPage(data: data);
                  },
                ),
                Positioned(
                  top: screenHeight * 0.08,
                  right: screenWidth * 0.05,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF76889A),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.02,
                  left: 0,
                  right: 0,
                  child: PageIndicator(currentPage: provider.currentPage),
                ),
                Positioned(
                  bottom: screenHeight * 0.05,
                  left: screenWidth * 0.15,
                  right: screenWidth * 0.15,
                  child: CustomButton(
                    text: provider.currentPage == 2 ? 'Get Started' : 'Continue',
                    onPressed: () {
                      if (provider.currentPage == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      } else {
                        provider.nextPage();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final Map<String, String> data;

  const _OnboardingPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.23),
              SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                child: Image.asset(
                  data['image']!,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  data['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff21252C),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Text(
                      data['description']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:14, // Adjusted for better scaling
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff76889A),
                        height: 1.4, // Improves text layout consistency
                      ),
                    );
                  },
                ),
              ),


            ],
          ),
        );
      },
    );
  }
}
