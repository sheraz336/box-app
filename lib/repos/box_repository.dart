import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
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
    _box.listenable().addListener(() {
      //update meta data of box if exist, else put it in map
     _update();
      notifyListeners();
    });
  }
  void _update(){
    _box.values.forEach((item) {
      if (_boxes[item.id] != null) {
        _boxes[item.id]!.update(item);
      } else {
        _boxes[item.id] = item;
      }
    });
  }
  Future<void> initListeners() async {
    final itemsBox = await Hive.openBox<ItemModel>(ItemRepository.boxName);

    //When items box changes
    itemsBox.listenable().addListener(() {
      _boxes.values.forEach((item) {
        _boxes.values.forEach((item) {

          //update items count of box
          final itemsCount =
              ItemRepository.instance.getBoxItems(item.id).length;
          _boxes[item.id]!..items = itemsCount;
        });
        notifyListeners();
      });
    });
  }

  List<BoxModel> getBoxes(String locationId) {
    final list = _boxes.values
        .where(
            (item) => item.locationId != null && item.locationId == locationId)
        .toList();
    return list;
  }


  List<BoxModel> getBoxesWithNoLocation() {
    final list = _boxes.values
        .where(
            (item) => item.locationId == null )
        .toList();
    return list;
  }

  Future<void> putBox(BoxModel model)async {
    await _box.put(model.id, model);
  }
}
