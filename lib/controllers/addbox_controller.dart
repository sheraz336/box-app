import 'package:flutter/material.dart';

class AddBoxController extends ChangeNotifier {
  TextEditingController boxNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  bool generateQrCode = false;

  void toggleQrCode() {
    generateQrCode = !generateQrCode;
    notifyListeners();
  }

  void addBox() {
    print("Box Added: ${boxNameController.text}");
  }
}
