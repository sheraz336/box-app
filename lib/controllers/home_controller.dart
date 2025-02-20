
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../repos/subscription_repository.dart';

class HomeController extends ChangeNotifier {
 List<LocationModel> get locations => LocationRepository.instance.list;
  // List<BoxModel> get boxes => BoxRepository.instance.list;
  // List<ItemModel> get items => ItemRepository.instance.list;
  // List<ItemModel> get itemsWithNoLocationOrBox => ItemRepository.instance.getItemsWithNoLocationOrBox();

  void deleteLocation(LocationModel item){
    //do not delete shared location
    if(SubscriptionRepository.instance.currentSubscription.isPremium && item.isShared()){
      throw Exception("Only owner can delete the box");
    }
    LocationRepository.instance.deleteLocation(item.locationId);
  }

  void deleteBox(BoxModel item){
    //do not delete shared boxes
    if(SubscriptionRepository.instance.currentSubscription.isPremium && item.isShared()){
      throw Exception("Only owner can delete the box");
    }
    BoxRepository.instance.deleteBox(item.id);
  }

  void deleteItem(ItemModel item){
    //do not delete shared items
    if(SubscriptionRepository.instance.currentSubscription.isPremium && item.isShared()){
      throw Exception("Only owner can delete the item");
    }
    ItemRepository.instance.deleteItem(item.id);
  }
}