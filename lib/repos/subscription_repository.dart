import 'dart:math';

import 'package:box_delivery_app/models/subscription_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/subscription_model.dart';

class SubscriptionRepository extends ChangeNotifier {
  static final boxName = "subscriptions";
  late SubscriptionModel _currentSubscription;
  late final Box _box;
  late DateTime _expiry;
  static final instance = SubscriptionRepository();

  SubscriptionModel get currentSubscription => _currentSubscription;

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
    final int id = _box.get("currentId", defaultValue: 0);
    final expiryTime = _box.get("expiryTime",
        defaultValue: DateTime.now().toUtc().millisecondsSinceEpoch);
    _currentSubscription = SubscriptionModel.getById(id);
    _expiry = DateTime.fromMillisecondsSinceEpoch(expiryTime, isUtc: true);
  }

  Future<void> changeTo(int id, {DateTime? expiry}) async {
    _currentSubscription = SubscriptionModel.getById(id);
    _expiry = expiry != null
        ? expiry
        : DateTime.now().toUtc().add(_currentSubscription.duration);
    await _box.put("currentId", id);
    await _box.put("expiryTime", _expiry.millisecondsSinceEpoch);

    //update in firebase
    if (FirebaseAuth.instance.currentUser != null)
      FirebaseFirestore.instance
          .collection("subscriptions")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'id': id, 'expiryTime': _expiry.millisecondsSinceEpoch});
    notifyListeners();
  }

  bool isExpired() {
    return _currentSubscription.id != SubscriptionModel.Free.id &&
        _expiry.difference(DateTime.now().toUtc()).inSeconds < 0;
  }

  bool canAddBox() {
    return !isExpired() &&
        BoxRepository.instance.list.length < _currentSubscription.maxBoxes;
  }

  bool canAddItem() {
    return !isExpired() &&
        ItemRepository.instance.list.length < _currentSubscription.maxItems;
  }

  bool canAddLocation() {
    return !isExpired() &&
        LocationRepository.instance.list.length <
            _currentSubscription.maxLocations;
  }

  Future<void> clear()async {
    _currentSubscription = SubscriptionModel.Free;
  }
}
