import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:flutter/material.dart';

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

  Future<void> addBox() async {
    BoxModel box = BoxModel(
      ownerId: getOwnerId(),
      id:  generateRandomId("box"),
      locationId: locationId,
      name: boxNameController.text,
      description:
          descriptionController.text.isEmpty ? "" : descriptionController.text,
      imagePath: imageUrl,
      tags: tagsController.text,
    );

    bool success = await BoxRepository.instance.putBox(box);
    if(!success)throw Exception("You have reached your subscription limit");

    // Save logic (send to API or database)
    print("Box Saved: ${box.name}");
  }
}
