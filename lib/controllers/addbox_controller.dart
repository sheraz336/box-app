import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:flutter/material.dart';

class AddBoxController extends ChangeNotifier {
  String? locationId;
  TextEditingController boxNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  bool generateQrCode = false;

  void toggleQrCode() {
    generateQrCode = !generateQrCode;
    notifyListeners();
  }

  Future<bool> addBox() async {
    try {
      if (boxNameController.text.isEmpty) {
        return false;
      }

      BoxModel box = BoxModel(
        id: "box-" + Random.secure().nextInt(10000).toString(),
        locationId: locationId,
        name: boxNameController.text,
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text,
        imagePath: "assets/onboarding2.png",
        tags: tagsController.text,
      );

      await BoxRepository.instance.putBox(box);

    // Save logic (send to API or database)
    print("Box Saved: ${box.name}");
    return true;
    }catch(e){
    print(e);
    return false;
    }
  }
}
