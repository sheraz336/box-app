import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import 'item_repository.dart';

class BoxRepository extends ChangeNotifier {
  static final boxName = "boxes";
  static final instance = BoxRepository();
  var _boxes = <String, BoxModel>{};
  late final Box<BoxModel> _box;

  List<BoxModel> get list => _boxes.values.toList(growable: false);

  Future<void> init() async {
    _box = await Hive.openBox<BoxModel>(boxName);
    _update();

    //listen for changes,
    _box.listenable().addListener(() {
      //update meta data of box if exist, else put it in map
      _update();
      fireNotify();
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

  Future<bool> putBox(BoxModel model) async {
    if (!SubscriptionRepository.instance.canAddBox()) return false;
    await _box.put(model.id, model);
    return true;
  }

  BoxModel? getBox(String? id) {
    if (id == null) return null;
    return _boxes[id];
  }

  Future<void> deleteBox(String id) async {
    _boxes.remove(id);
    await _box.delete(id);
  }

  Future<void> updateBox(BoxModel model) async {
    if (!_box.containsKey(model.id)) return;
    await _box.put(model.id, model);
  }

  Future<void> clear()async {
    _boxes.clear();
    await _box.clear();
  }
}
