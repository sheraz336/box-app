// controllers/add_location_controller.dart
import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

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
    LocationModel location = LocationModel(
      ownerId: getOwnerId(),
        locationId:  generateRandomId("location"),
        name: nameController.text,
        address: addressController.text,
        type: selectedType!,
        description: descriptionController.text.isEmpty
            ? ""
            : descriptionController.text,
        imagePath: imageUrl
    );

    final success = await LocationRepository.instance.putLocation(location);
    if(!success)throw Exception("You have reached your subscription limit");
    // Save logic (send to API or database)
    print("Location Saved: ${location.name}");
  }
}
