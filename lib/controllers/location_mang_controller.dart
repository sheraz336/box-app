import 'package:box_delivery_app/models/location_mang_model.dart';
import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  final List<LocationManagement> _boxes = [
    LocationManagement(
      id: '1',
      name: 'James Cooper',
      imagePath: 'assets/onboarding2.png',
      items: 210,
      value: 2000,
      isShared: true,
    ),
    LocationManagement(
      id: '2',
      name: 'James Cooper',
      imagePath: 'assets/onboarding2.png',
      items: 210,
      value: 2000,
      isShared: true,
    ),
    LocationManagement(
      id: '3',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding2.png',
      items: 34,
      value: 0,
      isShared: true,
    ),
    LocationManagement(
      id: '4',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding3.png',
      items: 34,
      value: 1000,
      isShared: true,
    ),
  ];

  List<LocationManagement> get boxes => _boxes;

  void editBox(String id) {

  }

  void deleteBox(String id) {
}
  void setSelectedTab(String tab) {
    notifyListeners();
  }

  void setSelectedLocation(String location) {
    notifyListeners();
  }

  void initializeBoxes() {
    notifyListeners();
  }
}
