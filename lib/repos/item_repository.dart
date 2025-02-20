import 'dart:async';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import 'invite_repository.dart';

class ItemRepository extends ChangeNotifier {
  static final boxName = "items";
  static final instance = ItemRepository();
  var _items = <String, ItemModel>{};
  late final Box<ItemModel> _box;

  //subscription for firestore owned items & items that are shared,
  List<String> _sharedLocationIds = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription,
      _sharedSubscription;

  List<ItemModel> get list => _items.values.toList(growable: false);

  Future<void> init() async {
    _box = await Hive.openBox<ItemModel>(boxName);
    _update();
    _box.listenable().addListener(() {
      //update meta data of item if exist, else put it in map
      _update();
      fireNotify();
    });
  }

  void initListeners() {
    SubscriptionRepository.instance.addListener(() {
      if (!SubscriptionRepository.instance.isPremiumActive()) return;
      startSync();
    });

    ///start sync for shared location
    InviteRepository.instance.addListener(() async {
      if (!SubscriptionRepository.instance.isPremiumActive()) return;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final newSharedLocationIds = InviteRepository.instance
          .getAcceptedInvites()
          .map((item) => item.locationId)
          .toList();

      print("items: new shared: $newSharedLocationIds");

      //delete items that no longer have permission to
      final items = list.where((item) =>
          (newSharedLocationIds
                      .indexWhere((locId) => locId != item.boxLocationId) !=
                  -1 ||
              newSharedLocationIds.isEmpty) &&
          item.ownerId != uid);
      for (var item in items) _items.remove(item.id);
      await _box.deleteAll(items.map((item) => item.id));
      print("items: removed boxes: ${items.length}");

      //cancel last
      await _sharedSubscription?.cancel();

      //update subscription for latest shared items
      if (newSharedLocationIds.isEmpty) return;
      _sharedSubscription = FirebaseFirestore.instance
          .collection("items")
          .where("boxLocationId", whereIn: newSharedLocationIds)
          .snapshots(includeMetadataChanges: true)
          .listen((snapshots) {
        print("shared items snapshots received ${snapshots.docChanges.length}");
        print(
            "pendingWrites: ${snapshots.metadata.hasPendingWrites}, fromCache: ${snapshots.metadata.isFromCache}");
        _onFirebaseItemChange(snapshots, denyCache: false);
      });
    });
  }

  //firebase sync
  Future<void> startSync() async {
    if (_subscription != null) return;
    if (FirebaseAuth.instance.currentUser == null ||
        !SubscriptionRepository.instance.currentSubscription.isPremium) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    //listen for owned firebase db item changes, to keep data in sync
    _subscription = FirebaseFirestore.instance
        .collection("items")
        .where("ownerId", isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshots) {
      print("Item snapshots received ${snapshots.docChanges.length}");
      print(
          "pendingWrites: ${snapshots.metadata.hasPendingWrites}, fromCache: ${snapshots.metadata.isFromCache}");
      _onFirebaseItemChange(snapshots);
    });

    //resolve pending writes
    await FirebaseFirestore.instance.waitForPendingWrites();

    //backup all items to firestore
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var item in list) {
        final id = FirebaseFirestore.instance.collection("items").doc(item.id);
        batch.set(id, item.toMap());
      }
      await batch.commit();
      print("Write Batch Items Commited");
    } catch (e) {
      print(e);
    }
  }

  void _onFirebaseItemChange(QuerySnapshot<Map<String, dynamic>> snapshots,
      {bool denyCache = true}) {
    //update local database only, when its not from cache & no pending writes
    if (!denyCache ||
        (!snapshots.metadata.isFromCache &&
            !snapshots.metadata.hasPendingWrites))
      snapshots.docChanges.forEach((doc) {
        final item = ItemModel.fromMap(doc.doc.data()!);
        switch (doc.type) {
          case DocumentChangeType.added:
            putItem(item, remoteWrite: false);
            break;
          case DocumentChangeType.modified:
            updateItem(item, remoteWrite: false);
            break;
          case DocumentChangeType.removed:
            deleteItem(item.id, remoteWrite: false);
            break;
        }
      });
  }

  void fireNotify() {
    notifyListeners();
  }

  void _update() {
    for (var item in _box.values) {
      _items[item.id] = item;
    }
  }

  //CRUD Operations

  List<ItemModel> getBoxesItems(List<String> boxIds) {
    final list = _items.values
        .where((item) =>
            item.boxId != null &&
            boxIds.indexWhere((id) => id == item.boxId) != -1)
        .toList();
    return list;
  }

  List<ItemModel> getBoxItems(String boxId) {
    final list = _items.values
        .where((item) => item.boxId != null && item.boxId == boxId)
        .toList();
    return list;
  }

  List<ItemModel> getLocationItems(String locationId) {
    final list = _items.values
        .where(
            (item) => item.locationId != null && item.locationId == locationId)
        .toList();
    return list;
  }

  List<ItemModel> getItemsWithNoLocationOrBox() {
    final list = _items.values
        .where((item) => item.locationId == null && item.boxId == null)
        .toList();
    return list;
  }

  Future<bool> putItem(ItemModel model, {bool remoteWrite = true}) async {
    if (!SubscriptionRepository.instance.canAddItem()) return false;
    if (_box.containsKey(model.id)) return false;
    await _box.put(model.id, model);

    //update in firestore
    if (remoteWrite &&
        SubscriptionRepository.instance.currentSubscription.isPremium) {
      FirebaseFirestore.instance
          .collection("items")
          .doc(model.id)
          .set(model.toMap());
    }
    return true;
  }

  Future<void> updateItem(ItemModel model, {bool remoteWrite = true}) async {
    if (!_box.containsKey(model.id)) return;
    await _box.put(model.id, model);

    //update in firestore
    if (remoteWrite &&
        SubscriptionRepository.instance.currentSubscription.isPremium) {
      FirebaseFirestore.instance
          .collection("items")
          .doc(model.id)
          .set(model.toMap());
    }
  }

  Future<void> deleteItem(String id, {bool remoteWrite = true}) async {
    _items.remove(id);
    await _box.delete(id);

    //update in firestore
    if (remoteWrite &&
        SubscriptionRepository.instance.currentSubscription.isPremium) {
      FirebaseFirestore.instance.collection("items").doc(id).delete();
    }
  }

  Future<void> clear() async {
    _items.clear();
    await _box.clear();
    await _subscription?.cancel();
    await _sharedSubscription?.cancel();
    _subscription = null;
    _sharedSubscription = null;
  }
}
