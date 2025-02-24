import 'dart:convert';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/views/subscription_screen.dart';
import 'package:collection/collection.dart';

enum ObjectType{
  Location,Box,Item
}
class QrModel{
  final ObjectType type;
  final ItemModel? item;
  final BoxModel? box;
  final LocationModel? location;

  QrModel({required this.type, this.item,this.box,this.location});

  static QrModel fromData(String data){
    final map = jsonDecode(data) as Map<dynamic,dynamic>;
    print("mappppp $map");
    final type = ObjectType.values.firstWhereOrNull((item)=>item.name==map["type"]);
    if(type == null)throw Exception("Invalid QR Code");
    switch(type){
      case ObjectType.Location:
        return QrModel(type: type,location: LocationModel.fromMap(map));
      case ObjectType.Box:
        return QrModel(type: type,box: BoxModel.fromMap(map));
      default:
        return QrModel(type: type,item: ItemModel.fromMap(map));
    }
  }

  String toQrData(){
    final map = Map.from(_getMapData());
    map["type"]= type.name;
    return jsonEncode(map);
  }

  String name(){
    switch(type){
      case ObjectType.Location:
        return location!.locationId;
      case ObjectType.Box:
        return box!.id;
      default:
        return item!.id;
    }
  }

  _getMapData(){
    switch(type){
      case ObjectType.Location:
        return location!.toMap();
      case ObjectType.Box:
        return box!.toMap();
      default:
        return item!.toMap();
    }
  }
}