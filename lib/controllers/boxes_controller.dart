import 'package:flutter/material.dart';
import '../models/box_model.dart';

class BoxesController extends ChangeNotifier {
  List<Box_Model> boxes = [
    Box_Model(title: "Gadget Box", imageUrl: "assets/item.png", itemCount: 34),
    Box_Model(title: "Gadget Box", imageUrl: "assets/item.png", itemCount: 34),
    Box_Model(title: "Gadget Box", imageUrl: "assets/item.png", itemCount: 34),
  ];

  List<Item_Model> items = [
    Item_Model(name: "G.I. Joe Figure", id: "#3203JKL", purchaseDate: "12-02-2024", imageUrl: "assets/item.png"),
  ];

  void deleteBox(int index) {
    boxes.removeAt(index);
    notifyListeners();
  }

  void editBox(int index) {
    // Handle edit functionality
  }
}
