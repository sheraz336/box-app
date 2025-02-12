import 'package:box_delivery_app/models/item_model.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class ItemRepository extends ChangeNotifier {
  static final boxName = "items";
  static final instance = ItemRepository();
  var _items = <String, ItemModel>{};
  late final Box<ItemModel> _box;

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

  void fireNotify(){
    notifyListeners();
  }

  void _update() {
    for(var item in _box.values){
      _items[item.id] = item;
    }
  }

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

  Future<void> putItem(ItemModel model) async {
    await _box.put(model.id, model);
  }

  Future<void> updateItem(ItemModel model) async {
    if (!_box.containsKey(model.id)) return;
    await _box.put(model.id, model);
  }

  Future<void> deleteItem(String id) async {
    _items.remove(id);
    await _box.delete(id);
  }
}
