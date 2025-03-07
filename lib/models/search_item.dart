import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/models/qr_model.dart';

class SearchItem{
  final ObjectType type;
  final ItemModel? item;
  final BoxModel? box;
  final LocationModel? location;

  SearchItem({required this.type, this.item,this.box,this.location});

  String name(){
    switch(type){
      case ObjectType.Location:
        return location!.name;
      case ObjectType.Box:
        return box!.name;
      default:
        return item!.name;
    }
  }

  getMapData(){
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