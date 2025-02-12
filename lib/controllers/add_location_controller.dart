// controllers/add_location_controller.dart
import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:flutter/material.dart';

class AddLocationController with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? selectedType;
  String? imageUrl;
  String? _selectedTypeError;

  String? get selectedTypeError => _selectedTypeError;

  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  void uploadImage(String path) {
    imageUrl = path;
    notifyListeners();
  }

  Future<void> saveLocation() async {
    try {
      LocationModel location = LocationModel(
        id: "location-" + Random.secure().nextInt(10000).toString(),
        name: nameController.text,
        address: addressController.text,
        type: selectedType!,
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text,
        imagePath: imageUrl
      );

      await LocationRepository.instance.putLocation(location);

      // Save logic (send to API or database)
      print("Location Saved: ${location.name}");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
