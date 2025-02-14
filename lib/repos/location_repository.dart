import 'dart:async';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class LocationRepository extends ChangeNotifier {
  static final boxName = "locations";
  static final instance = LocationRepository();
  var _locations = <String, LocationModel>{};
  late final Box<LocationModel> _box;

  //subscription for firestore owned location & location that are shared,
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription,_sharedSubscription;

  List<LocationModel> get list => _locations.values.toList(growable: false);

  Future<void> init() async {
    _box = await Hive.openBox<LocationModel>(boxName);
    _update();
    _updateBoxes();
    _updateItemsCount();

    //listen to changes
    _box.listenable().addListener(() {
      //update meta data of locations if exist, else put it in map
      print("Box listenable");
      _update();
      fireNotify();
    });
  }

  Future<void> initListeners() async {
    //When boxes box changes
    BoxRepository.instance.addListener(() {
      _updateBoxes();
    });

    //When items box changes
    ItemRepository.instance.addListener(() {
      _updateItemsCount();
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
        .collection("locations")
        .where("ownerId", isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshots) {
      print("location snapshots received ${snapshots.docChanges.length}");
      print("pendingWrites: ${snapshots.metadata.hasPendingWrites}, fromCache: ${snapshots.metadata.isFromCache}");
      _onFirebaseItemChange(snapshots);
    });

    //resolve pending writes
    await FirebaseFirestore.instance.waitForPendingWrites();
  }

  void _onFirebaseItemChange(QuerySnapshot<Map<String, dynamic>> snapshots){
    //update local database only, when its not from cache & no pending writes
    if (!snapshots.metadata.isFromCache &&
        !snapshots.metadata.hasPendingWrites)
      snapshots.docChanges.forEach((doc) {
        final item = LocationModel.fromMap(doc.doc.data()!);
        switch (doc.type) {
          case DocumentChangeType.added:
            putLocation(item,remoteWrite: false);
            break;
          case DocumentChangeType.modified:
            updateLocation(item,remoteWrite: false);
            break;
          case DocumentChangeType.removed:
            deleteLocation(item.locationId,remoteWrite: false);
            break;
        }
      });
  }

  void fireNotify(){
    notifyListeners();
  }

  void _update() {
    for(var item in _box.values){
      if (_locations[item.locationId] != null) {
        _locations[item.locationId]!.update(item);
      } else {
        _locations[item.locationId] = item;
      }
    }
  }

  void _updateBoxes() {
    _locations.values.forEach((item) {
      _locations.values.forEach((item) {
        //update boxes
        _locations[item.locationId]!..boxes = BoxRepository.instance.getBoxes(item.locationId);
      });
    });
    notifyListeners();
  }

  void _updateItemsCount() {
    _locations.values.forEach((item) {
      _locations.values.forEach((item) {
        //update items count ( all items in boxes + all items directly in location)
        final boxesItemCount = ItemRepository.instance
            .getBoxesItems(item.boxes.map((item) => item.id).toList())
            .length;
        final locationItemsCount =
            ItemRepository.instance.getLocationItems(item.locationId).length;
        _locations[item.locationId]!..items = boxesItemCount + locationItemsCount;
      });
      notifyListeners();
    });
  }

  LocationModel? getLocation(String? id) {
    if(id==null)return null;
    return _locations[id];
  }

  Future<bool> putLocation(LocationModel location,{bool remoteWrite=true}) async {
    if (!SubscriptionRepository.instance.canAddLocation()) return false;
    await _box.put(location.locationId, location);
    print("fff ${FirebaseAuth.instance.currentUser!.uid}");
    //update in firestore
    if(remoteWrite &&SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("locations").doc(location.locationId).set(location.toMap());
    }

    return true;
  }

  Future<void> deleteLocation(String id,{bool remoteWrite=true}) async {
    _locations.remove(id);
    await _box.delete(id);

    //update in firestore
    if(remoteWrite && SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("locations").doc(id).delete();
    }
  }

  Future<void> updateLocation(LocationModel model,{bool remoteWrite=true}) async {
    if (!_box.containsKey(model.locationId)) return;
    await _box.put(model.locationId, model);

    //update in firestore
    if(remoteWrite && SubscriptionRepository.instance.currentSubscription.isPremium){
      FirebaseFirestore.instance.collection("locations").doc(model.locationId).set(model.toMap());
    }
  }

  Future<void> clear()async {
    _locations.clear();
    await _box.clear();
    await _subscription?.cancel();
    await _sharedSubscription?.cancel();
    _subscription=null;
    _sharedSubscription=null;
  }
}
