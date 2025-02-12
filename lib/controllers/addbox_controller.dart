import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:flutter/material.dart';

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
    try {
      BoxModel box = BoxModel(
        id: "box-" + Random.secure().nextInt(10000).toString(),
        locationId: locationId,
        name: boxNameController.text,
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text,
        imagePath: imageUrl,
        tags: tagsController.text,
      );

      await BoxRepository.instance.putBox(box);

      // Save logic (send to API or database)
      print("Box Saved: ${box.name}");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
