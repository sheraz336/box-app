import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class LocationRepository extends ChangeNotifier {
  static final boxName = "locations";
  static final instance = LocationRepository();
  var _locations = <String, LocationModel>{};
  late final Box<LocationModel> _box;

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

  Future<bool> putLocation(LocationModel location) async {
    if (!SubscriptionRepository.instance.canAddLocation()) return false;
    await _box.put(location.locationId, location);
    return true;
  }

  Future<void> deleteLocation(String id) async {
    _locations.remove(id);
    await _box.delete(id);
  }

  Future<void> updateLocation(LocationModel model) async {
    if (!_box.containsKey(model.locationId)) return;
    await _box.put(model.locationId, model);

  }

  Future<void> clear()async {
    _locations.clear();
    await _box.clear();
  }
}
