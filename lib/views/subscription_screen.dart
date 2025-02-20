import 'package:box_delivery_app/main.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'auth/sign_in/sign_in.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var selectedPlan = 1;
  bool isLoading = false;

  void onSubscribe(int id) async {
    if (isLoading) return;
    try {
      if (id == SubscriptionRepository.instance.currentSubscription.id &&
          !SubscriptionRepository.instance.isExpired()) {
        showAlertDialog(
            context, "Error", "You already are subscribed to this plan",
            true, () {});
        return;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Requires Sign in"),
                content: Text(
                    "This requires you to have an account. Sign in and continue?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                          MaterialPageRoute(builder: (c) => SignInScreen()));
                    },
                    child: Text("Sign In"),
                  ),
                ],
              ),
        );
        return;
      }

      isLoading = true;
      await SubscriptionRepository.instance.changeTo(id);
      isLoading = false;
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    final currentPlan = SubscriptionRepository.instance.currentSubscription.id;
    if (currentPlan > 0) selectedPlan = currentPlan;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE25E00), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Text(
                "Subscribe to Premium",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Subscription Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Ensures alignment
                  children: [
                    // Pro Plan Card
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => selectedPlan = 1),
                            child: SubscriptionCard(
                              title: "Pro",
                              price: "£9.99",
                              subText: "One-time Purchase",
                              isSelected: selectedPlan == 1,
                            ),
                          ),
                          SizedBox(height: 10),
                          FeatureList(
                            features: [
                              "More Locations",
                              "More Boxes",
                              "More Items",
                              "No Ads",
                              "No Cloud Sync"
                            ],
                            isProPlusCloud:
                            false, // ❌ This is just Pro, not Pro+ Cloud
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),

                    // Pro+ Cloud Plan Card
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => selectedPlan = 2),
                            child: SubscriptionCard(
                              title: "Pro+ Cloud",
                              price: "£49.99",
                              subText: "Billed Annually",
                              isSelected: selectedPlan == 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          FeatureList(
                            features: [
                              "Unlimited Locations",
                              "Unlimited Boxes",
                              "Unlimited Items",
                              "No Ads",
                              "Cloud Sync",
                              "Sharing"
                            ],
                            isProPlusCloud:
                            true, // ✅ This is Pro+ Cloud, so "No Ads" should have a tick
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Subscribe Button
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE25E00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => onSubscribe(selectedPlan),
                    child: Text(
                      "Subscribe Now",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Subscription Card Component
class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String subText;
  final bool isSelected;

  SubscriptionCard({
    required this.title,
    required this.price,
    required this.subText,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      width: 145,
      height: 145,
      // Ensures both cards have equal height
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.white,
          width: isSelected ? 1 : 1,
        ),
        boxShadow:
        isSelected ? [BoxShadow(color: Colors.black26, blurRadius: 6)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
          //SizedBox(height: 5),
          Spacer(),
          Text(
            subText,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.black54 : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureList extends StatelessWidget {
  final List<String> features;
  final bool isProPlusCloud; // Determines if it's the Pro+ Cloud plan

  FeatureList({required this.features, this.isProPlusCloud = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
      children: features.map((feature) {
        // Check if the feature is "No Ads"
        bool isNoAds = feature.toLowerCase() == "no ads";

        // Determine if it should be a cross (❌) or tick (✅)
        bool showTick = (isNoAds && isProPlusCloud) ||
            (!feature.toLowerCase().contains("no"));
        String iconPath = showTick ? 'assets/tick.svg' : 'assets/Cross.svg';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: 14,
                width: 14,
              ),
              SizedBox(width: 8),
              Text(
                feature,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
