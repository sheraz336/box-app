
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class HomeController extends ChangeNotifier {
  final List<BoxModel> _boxes = [
    BoxModel(
      id: '1',
      name: 'James Cooper',
      imagePath: 'assets/onboarding2.png',
      items: 210,
      value: 2000,
      isShared: true,
    ),
    BoxModel(
      id: '2',
      name: 'James Cooper',
      imagePath: 'assets/onboarding2.png',
      items: 210,
      value: 2000,
      isShared: true,
    ),
    BoxModel(
      id: '3',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding2.png',
      items: 34,
      value: 0,
      isShared: false,
    ),
    BoxModel(
      id: '4',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding3.png',
      items: 34,
      value: 0,
      isShared: false,
    ),
  ];

  List<BoxModel> get boxes => _boxes;

  void editBox(String id) {
  }

  void deleteBox(String id) {
  }
}