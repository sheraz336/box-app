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
    final subRepo = context.watch<SubscriptionRepository>();
    final currentSub = subRepo.currentSubscription;

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscriptions"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  ...[0, 1, 2].map((item) {
                    final sub = SubscriptionModel.getById(item);
                    bool isCurrentSub = sub.id == currentSub.id;

                    String maxLocations = !sub.isPremium
                        ? sub.maxLocations.toString()
                        : "Unlimited";
                    String maxBoxes =
                        !sub.isPremium ? sub.maxBoxes.toString() : "Unlimited";
                    String maxItems =
                        !sub.isPremium ? sub.maxItems.toString() : "Unlimited";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          sub.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Max Locations: ${maxLocations}"),
                            Text("Max Boxes: ${maxBoxes}"),
                            Text("Max Items: ${maxItems}"),
                            if (sub.isPremium) Text("Backed up to server"),
                            if (sub.isPremium) Text("Sync across devices")
                          ],
                        ),
                        OutlinedButton(
                            onPressed:
                                isCurrentSub ? null : () => onSubscribe(sub.id),
                            child: Text(
                              isCurrentSub ? "Current" : "Subscribe",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFE25E00),
                            ))
                      ],
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
