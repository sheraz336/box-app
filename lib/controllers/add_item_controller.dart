import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';

import '../repos/location_repository.dart';
import '../repos/subscription_repository.dart';

class AddItemsController extends ChangeNotifier {
  final TextEditingController itemNameController = TextEditingController();
  String? boxId, locationId;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController qrBarcodeController = TextEditingController();

  String? imageUrl;


  bool generateQrCode = false;

  void toggleQrCode() {
    generateQrCode = !generateQrCode;
    notifyListeners();
  }

  void selectImage(String url) {
    imageUrl = url;
    notifyListeners();
  }

  Future<ItemModel> addItem() async {
    if ((locationId != null && boxId != null)) {
      throw Exception("Either choose Box Or Location");
    }
    //if adding, to a shared box, the owner would be the location owner
    String? ownerId = getOwnerId();
    final box = BoxRepository.instance.getBox(boxId);
    final location = LocationRepository.instance.getLocation(box?.locationId);

    if (ownerId != null &&
        box != null &&
        location != null &&
        location.isShared()) {
      ownerId = location.ownerId!;
    }

    final item = ItemModel(
      ownerId: ownerId,
      id: generateRandomId("item"),
      name: itemNameController.text,
      quantity: int.parse(
          quantityController.text.isEmpty ? "0" : quantityController.text),
      boxId: boxId,
      boxLocationId: BoxRepository.instance.getBox(boxId)?.locationId,
      locationId: locationId,
      description: descriptionController.text,
      imagePath: imageUrl,
      purchaseDate: purchaseDateController.text,
      tags: tagsController.text,
      value: double.parse(
          valueController.text.isEmpty ? "0" : valueController.text),
    );

    final success = await ItemRepository.instance.putItem(item);
    if (!success) {
      final msg =
          (SubscriptionRepository.instance.currentSubscription.isPremium &&
                  SubscriptionRepository.instance.isExpired())
              ? "Your subscription is expired"
              : "You have reached your items limit";
      throw Exception(msg);
    }

    // Save the newItem to Firestore, database, or local storage
    debugPrint("Item Added: ${item.name}");
    return item;
  }
}
