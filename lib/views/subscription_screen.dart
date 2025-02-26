import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../repos/subscription_repository.dart';
import '../utils.dart';
import 'auth/sign_in/sign_in.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var selectedPlan = 1;
  bool isLoading = false;
  final String _proProductId = 'pro'; // One-time purchase
  final String _proPlusCloudProductId = 'pro_plus_cloud'; // Subscription
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
  }

  void onSubscribe(int id) async {
    if (isLoading) return;
    try {
      if (id == SubscriptionRepository.instance.currentSubscription.id &&
          !SubscriptionRepository.instance.isExpired()) {
        showAlertDialog(context, "Error",
            "You already are subscribed to this plan", true, () {});
        return;
      }
      print("aaaa ${FirebaseAuth.instance.currentUser}");
      if (FirebaseAuth.instance.currentUser == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Requires Sign in"),
            content: Text(
                "This requires you to have an account. Sign in and continue?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => SignInScreen()));
                },
                child: Text("Sign In"),
              ),
            ],
          ),
        );
        return;
      }

      isLoading = true;
      setState(() {});
      //subscription
      final productId = id == 1 ? _proProductId : _proPlusCloudProductId;
      final ProductDetails? product =
          _products.firstWhereOrNull((p) => p.id == productId);

      if (product == null) {
        print("Product not found");
        // showAlertDialog(context, "Error", "Product not found", true, (){});
        await SubscriptionRepository.instance.changeTo(selectedPlan);
        showAlertDialog(context, "Info", "DevMode: Granted subscription for testing", true, (){});
        isLoading = false;
        setState(() {});
        return;
      }

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      if (id == 1) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      print(e);
      isLoading = false;
      setState(() {});
    }
  }

  void _initializeInAppPurchase() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!isAvailable) return;

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails({
      _proProductId,
      _proPlusCloudProductId,
    });

    if (response.notFoundIDs.isNotEmpty) {
      print('Some products not found: ${response.notFoundIDs}');
    }

    setState(() {
      _products = response.productDetails;
    });

    _subscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        print('Purchase Stream Error: $error');
      },
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print('Purchase Error: ${purchaseDetails.error}');
        isLoading = false;
        setState(() {});
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _proProductId) {
      print('Pro Purchase Successful!');
      await SubscriptionRepository.instance.changeTo(1);
      isLoading = false;
      setState(() {});
      return;
    } else if (purchaseDetails.productID == _proPlusCloudProductId) {
      print('Pro+ Cloud Subscription Successful!');
      await SubscriptionRepository.instance.changeTo(2);
      isLoading = false;
      setState(() {});
    }
  }




  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
            colors: [Color(0xFF06a3e0), Colors.white],
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
                              // price: "£49.99",
                              // subText: "Billed Annually",
                              isSelected: selectedPlan == 2,
                              price: _products.firstWhereOrNull((p) => p.id == _proPlusCloudProductId)?.price ?? "£49.99",
                              subText: "Billed Annually", // Manually setting since `ProductDetails` does not provide a period
                              // isSelected: selectedPlan == 1,
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
                      backgroundColor: Color(0xFF06a3e0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => onSubscribe(selectedPlan),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4,
                            ),
                          )
                        : Text(
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
