import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
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
      if (_locations[item.id] != null) {
        _locations[item.id]!.update(item);
      } else {
        _locations[item.id] = item;
      }
    }
  }

  void _updateBoxes() {
    _locations.values.forEach((item) {
      _locations.values.forEach((item) {
        //update boxes
        _locations[item.id]!..boxes = BoxRepository.instance.getBoxes(item.id);
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
            ItemRepository.instance.getLocationItems(item.id).length;
        _locations[item.id]!..items = boxesItemCount + locationItemsCount;
      });
      notifyListeners();
    });
  }

  LocationModel? getLocation(String? id) {
    if(id==null)return null;
    return _locations[id];
  }

  Future<void> putLocation(LocationModel location) async {
    await _box.put(location.id, location);
  }

  Future<void> deleteLocation(String id) async {
    _locations.remove(id);
    await _box.delete(id);
  }

  Future<void> updateLocation(LocationModel model) async {
    if (!_box.containsKey(model.id)) return;
    await _box.put(model.id, model);

  }
}
