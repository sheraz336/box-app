// controllers/add_location_controller.dart
import 'package:flutter/material.dart';
import '../models/LocationModel.dart';

class AddLocationController with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? selectedType;
  String? imageUrl;

  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  void uploadImage(String path) {
    imageUrl = path;
    notifyListeners();
  }

  void saveLocation() {
    if (nameController.text.isEmpty || addressController.text.isEmpty || selectedType == null) {
      return;
    }

    LocationModel location = LocationModel(
      name: nameController.text,
      address: addressController.text,
      type: selectedType!,
      description: descriptionController.text.isEmpty ? null : descriptionController.text,
      imageUrl: imageUrl,
    );

    // Save logic (send to API or database)
    print("Location Saved: ${location.name}");
  }
}
