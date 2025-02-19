import 'package:box_delivery_app/main.dart';
import 'package:box_delivery_app/models/subscription_model.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/sign_in/sign_in.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlan = 0; // 0 for Pro, 1 for Pro+ Cloud

  void onSubscribe(int id) {
    if (id > 0 && FirebaseAuth.instance.currentUser == null) {
      showConfirmDialog(
          context,
          "Requires Sign in",
          "This requires you to have an account. Sign in and continue?",
          true, () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => SignInScreen()));
      });
      return;
    }
    SubscriptionRepository.instance.changeTo(id);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            children: [
              // Back Button and Title
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
                  children: [
                    // Pro Plan Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedPlan = 0),
                        child: SubscriptionCard(
                          title: "Pro",
                          price: "£9.99",
                          subText: "One-time Purchase",
                          features: [
                            "More Locations",
                            "More Boxes",
                            "More Items",
                            "No Ads",
                            "No Cloud Sync"
                          ],
                          isSelected: selectedPlan == 0,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    // Pro+ Cloud Plan Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedPlan = 1),
                        child: SubscriptionCard(
                          title: "Pro+ Cloud",
                          price: "£49.99",
                          subText: "Billed Annually",
                          features: [
                            "Unlimited Locations",
                            "Unlimited Boxes",
                            "Unlimited Items",
                            "No Ads",
                            "Cloud Sync",
                            "Sharing"
                          ],
                          isSelected: selectedPlan == 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Subscribe Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    onPressed: () {},
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

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String subText;
  final List<String> features;
  final bool isSelected;

  SubscriptionCard({
    required this.title,
    required this.price,
    required this.subText,
    required this.features,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.black26, blurRadius: 6)]
            : [],
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
          SizedBox(height: 5),
          Text(
            subText,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.black54 : Colors.white70,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: features
                .map(
                  (feature) => Row(
                children: [
                  Icon(
                    feature == "No Cloud Sync"
                        ? Icons.close
                        : Icons.check,
                    color: feature == "No Cloud Sync"
                        ? Colors.red
                        : isSelected
                        ? Colors.black
                        : Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
