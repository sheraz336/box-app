
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
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
      isShared: true, tags: '', description: '',
    ),
    BoxModel(
      id: '2',
      name: 'James Cooper',
      imagePath: 'assets/onboarding2.png',
      items: 210,
      value: 2000,
      isShared: true, tags: '', description: '',
    ),
    BoxModel(
      id: '3',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding2.png',
      items: 34,
      value: 0,
      isShared: false, tags: '', description: '',
    ),
    BoxModel(
      id: '4',
      name: 'Gadget Box',
      imagePath: 'assets/onboarding3.png',
      items: 34,
      value: 0,
      isShared: false, tags: '', description: '',
    ),
  ];

  // List<LocationModel> get locations => LocationRepository.instance.list;
  // List<BoxModel> get boxes => BoxRepository.instance.list;
  // List<ItemModel> get items => ItemRepository.instance.list;
  // List<ItemModel> get itemsWithNoLocationOrBox => ItemRepository.instance.getItemsWithNoLocationOrBox();

  void deleteLocation(LocationModel item){
    LocationRepository.instance.deleteLocation(item.locationId);
  }

  void deleteBox(BoxModel item){
    BoxRepository.instance.deleteBox(item.id);
  }

  void deleteItem(ItemModel item){
    ItemRepository.instance.deleteItem(item.id);
  }
}