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
          'Effortlessly manage your boxes, items, and\n storage locations all in one place. Stay \norganised like never before!',
    },
    {
      'image': 'assets/onboarding2.png',
      'title': 'Track Every Item',
      'description':
          'Add, categorize, and secure your items with\nease. No more losing track of what\'s stored\nwhere!',
    },
    {
      'image': 'assets/onboarding3.png',
      'title': 'Secure and\nAccessible',
      'description':
          'Enjoy secure access to your stored items\nanytime, anywhere. Simple tracking ensures\nyour items are always just where you need\nthem.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                  top: 30,
                  right: 20,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF76889A),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: PageIndicator(currentPage: provider.currentPage),
                ),
                Positioned(
                  bottom: 36,
                  left: 0,
                  right: 0,
                  child: CustomButton(
                    text:
                        provider.currentPage == 2 ? 'Get Started' : 'Continue',
                    onPressed: () {
                      if (provider.currentPage == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 90),
          Image.asset(
            data['image']!,
            width: 323,
            height: 255,
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              data['title']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff21252C),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['description']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xff76889A),
            ),
          ),
        ],
      ),
    );
  }
}
