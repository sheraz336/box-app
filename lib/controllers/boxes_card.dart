import 'package:flutter/material.dart';

import '../models/box_model.dart';
import '../models/boxes_model.dart';

class BoxController with ChangeNotifier {
  final List<BoxModel> _boxes = [
    BoxModel(
      id: '3',
      name: 'Gadget Box',
      imagePath: 'assets/final_cooper.png',
      items: 34,
      value: null,
      isShared: false,
    ),
    BoxModel(
      id: '4',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding3.png',
      items: 34,
      value: null,
      isShared: false,
    ),
  ];
  List<BoxModel> get boxes => _boxes;

  void editBox(String id) {}

  void deleteBox(String id) {}
}
