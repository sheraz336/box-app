import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemsController extends ChangeNotifier {
  List<ItemModel> items = [
    ItemModel(
        name: "Wireless Headphones",
        id: "#2033JKL",
        purchaseDate: "12-02-2024",
        imagePath: 'assets/edit_item.png'),
    ItemModel(
        name: "Smart Watch",
        id: "#5678XYZ",
        purchaseDate: "01-10-2023",
        imagePath: 'assets/edit_item.png'),ItemModel(
        name: "Wireless Headphones",
        id: "#2033JKL",
        purchaseDate: "12-02-2024",
        imagePath: 'assets/edit_item.png'),
    ItemModel(
        name: "Smart Watch",
        id: "#5678XYZ",
        purchaseDate: "01-10-2023",
        imagePath: 'assets/edit_item.png'),
  ];

  void updateItems(List<ItemModel> updatedItems) {
    items = updatedItems;
    notifyListeners();
  }
}
