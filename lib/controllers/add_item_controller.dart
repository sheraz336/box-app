import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:flutter/material.dart';


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

  void selectImage(String url) {
    imageUrl = url;
    notifyListeners();
  }

  Future<void> addItem()async {
    if ((locationId != null && boxId != null)) {
      throw Exception("Either choose Box Or Location");
    }
    final item = ItemModel(
      id: "item-" + Random.secure().nextInt(10000).toString(),
      name: itemNameController.text,
      quantity: int.parse(quantityController.text.isEmpty ? "0":quantityController.text),
      boxId: boxId,
      locationId: locationId,
      description: descriptionController.text,
      imagePath:  imageUrl,
      purchaseDate: purchaseDateController.text,
      tags: tagsController.text,
      value: double.parse(valueController.text.isEmpty ? "0" :valueController.text),
    );

    final success = await ItemRepository.instance.putItem(item);
    if(!success)throw Exception("You have reached your subscription limit");

    // Save the newItem to Firestore, database, or local storage
    debugPrint("Item Added: ${item.name}");
  }
}
