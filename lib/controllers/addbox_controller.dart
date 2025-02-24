import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:flutter/material.dart';

import '../repos/subscription_repository.dart';
import '../utils.dart';

class AddBoxController extends ChangeNotifier {
  String? locationId;
  TextEditingController boxNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  String? imageUrl;

  bool generateQrCode = false;

  void toggleQrCode() {
    generateQrCode = !generateQrCode;
    notifyListeners();
  }

  Future<BoxModel> addBox() async {
    String? ownerId = getOwnerId();

    //if adding, to a shared location, the owner would be the location owner
    final location = LocationRepository.instance.getLocation(locationId);
    if (ownerId != null &&
        locationId != null &&
        location != null &&
        location.isShared()) {
      ownerId = location.ownerId!;
    }
    BoxModel box = BoxModel(
      ownerId: ownerId,
      id: generateRandomId("box"),
      locationId: locationId,
      name: boxNameController.text,
      description:
          descriptionController.text.isEmpty ? "" : descriptionController.text,
      imagePath: imageUrl,
      tags: tagsController.text,
    );

    bool success = await BoxRepository.instance.putBox(box);
    if (!success) {
      final msg =
          (SubscriptionRepository.instance.currentSubscription.isPremium &&
                  SubscriptionRepository.instance.isExpired())
              ? "Your subscription is expired"
              : "You have reached your boxes limit";
      throw Exception(msg);
    }

    // Save logic (send to API or database)
    print("Box Saved: ${box.name}");
    return box;
  }
}
