import 'package:flutter/material.dart';
import '../models/add_item_model.dart';


class AddItemsController extends ChangeNotifier {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController boxController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController qrBarcodeController = TextEditingController();

  String? imageUrl;

  void selectImage(String url) {
    imageUrl = url;
    notifyListeners();
  }

  void addItem() {
    if (itemNameController.text.isEmpty || boxController.text.isEmpty) {
      return;
    }

    final newItem = AddItemsModel(
      itemName: itemNameController.text,
      box: boxController.text,
      description: descriptionController.text,
      purchaseDate: purchaseDateController.text,
      value: valueController.text,
      quantity: quantityController.text,
      tags: tagsController.text,
      qrBarcode: qrBarcodeController.text,
      imageUrl: imageUrl,
    );

    // Save the newItem to Firestore, database, or local storage
    debugPrint("Item Added: ${newItem.itemName}");
  }
}
