import 'dart:async';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import 'item_repository.dart';

class BoxRepository extends ChangeNotifier {
  static final boxName = "boxes";
  static final instance = BoxRepository();
  var _boxes = <String, BoxModel>{};
  late final Box<BoxModel> _box;

  List<BoxModel> get list => _boxes.values.toList(growable: false);

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription,_sharedSubscription;

  Future<void> init() async {
    _box = await Hive.openBox<BoxModel>(boxName);
    _update();

    //listen for changes,
    _box.listenable().addListener(() {
      //update meta data of box if exist, else put it in map
      _update();
      fireNotify();
    });

    SubscriptionRepository.instance.addListener(() {
      if (!SubscriptionRepository.instance.currentSubscription.isPremium)
        return;
      startSync();
    });
  }

  Future<void> startSync() async {
    if (_subscription != null) return;
    if (FirebaseAuth.instance.currentUser == null ||
        !SubscriptionRepository.instance.currentSubscription.isPremium) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    //listen for owned firebase db item changes, to keep data in sync
    _subscription = FirebaseFirestore.instance
        .collection("boxes")
        .where("ownerId", isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshots) {
      print("box snapshots received ${snapshots.docChanges.length}");
      print("pendingWrites: ${snapshots.metadata.hasPendingWrites}, fromCache: ${snapshots.metadata.isFromCache}");
      _onFirebaseItemChange(snapshots);
      snapshots.docChanges.forEach((doc) {
        final item = BoxModel.fromMap(doc.doc.data()!);
        print("box ${doc.type} ${item.toMap()}");
      });
    });

    //resolve pending writes
    await FirebaseFirestore.instance.waitForPendingWrites();
  }

  void _onFirebaseItemChange(QuerySnapshot<Map<String, dynamic>> snapshots){
    //update local database only, when its not from cache & no pending writes
    if (!snapshots.metadata.isFromCache &&
        !snapshots.metadata.hasPendingWrites)
      snapshots.docChanges.forEach((doc) {
        final item = BoxModel.fromMap(doc.doc.data()!);
        switch (doc.type) {
          case DocumentChangeType.added:
            putBox(item,remoteWrite: false);
            break;
          case DocumentChangeType.modified:
            updateBox(item,remoteWrite: false);
            break;
          case DocumentChangeType.removed:
            deleteBox(item.id,remoteWrite: false);
            break;
        }
      });
  }

  void _update() {
    for (var item in _box.values) {
      if (_boxes[item.id] != null) {
        _boxes[item.id]!.update(item);
      } else {
        _boxes[item.id] = item;
      }
    }
  }

  void _updateItemsCount() {
    _boxes.values.forEach((item) {
      _boxes.values.forEach((item) {
        //update items count of box
        final itemsCount = ItemRepository.instance.getBoxItems(item.id).length;
        _boxes[item.id]!..items = itemsCount;
      });
      notifyListeners();
    });
  }

  Future<void> initListeners() async {
    //when items box changes
    ItemRepository.instance.addListener(() {
      _updateItemsCount();
    });

    //when items box changes
    LocationRepository.instance.addListener(() {
      _boxes.values.forEach((item) {
        _boxes[item.id]
          ?..location =
              LocationRepository.instance.getLocation(item.locationId);
      });
    });
  }

  void fireNotify() {
    notifyListeners();
  }

  List<BoxModel> getBoxes(String locationId) {
    final list = _boxes.values
        .where(
            (item) => item.locationId != null && item.locationId == locationId)
        .toList();
    return list;
  }

  List<BoxModel> getBoxesWithNoLocation() {
    final list =
        _boxes.values.where((item) => item.locationId == null).toList();
    return list;
  }

  Future<bool> putBox(BoxModel model,{bool remoteWrite=true}) async {
    if (!SubscriptionRepository.instance.canAddBox()) return false;
    await _box.put(model.id, model);

    //update in firestore
    if(remoteWrite && SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("boxes").doc(model.id).set(model.toMap());
    }

    return true;
  }

  BoxModel? getBox(String? id) {
    if (id == null) return null;
    return _boxes[id];
  }

  Future<void> deleteBox(String id,{bool remoteWrite=true}) async {
    _boxes.remove(id);
    await _box.delete(id);

    //update in firestore
    if(remoteWrite && SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("boxes").doc(id).delete();
    }
  }

  Future<void> updateBox(BoxModel model,{bool remoteWrite=true}) async {
    if (!_box.containsKey(model.id)) return;
    await _box.put(model.id, model);

    //update in firestore
    if(remoteWrite && SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("boxes").doc(model.id).set(model.toMap());
    }
  }

  Future<void> clear()async {
    _boxes.clear();
    await _box.clear();
    await _subscription?.cancel();
    await _sharedSubscription?.cancel();
    _subscription=null;
    _sharedSubscription=null;
  }
}
