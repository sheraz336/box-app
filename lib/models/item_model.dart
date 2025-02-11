// this model is for home_screen.dart
import 'package:hive_flutter/adapters.dart';
part 'item_model.g.dart';
@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
   String id;
  @HiveField(1)
   String name;
  @HiveField(2)
   String address;
  @HiveField(3)
   String type;
  @HiveField(4)
   String description;
  @HiveField(5)
   String imagePath;

  int items = 0;
  List<BoxModel> boxes=[];
  double value = 0;

  LocationModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.type,
      required this.description,
      required this.imagePath});

  void update(LocationModel model){
    this.name = model.name;
    this.address = model.address;
    this.type = model.address;
    this.type = model.type;
    this.description = model.description;
    this.imagePath = model.imagePath;
  }
}

@HiveType(typeId: 1)
class BoxModel extends HiveObject {
  @HiveField(0)
   String id;
  @HiveField(1)
   String name;
  @HiveField(2)
   String tags;
  @HiveField(3)
   String description;
  @HiveField(4)
   String imagePath;
  @HiveField(5)
   String? locationId;

  LocationModel? location;
  int items;
  double value;
  bool isShared;

  BoxModel({
    this.locationId = "",
    required this.tags,
    required this.description,
    required this.id,
    required this.name,
    required this.imagePath,
    this.location,
    this.items = 0,
    this.value = 0,
    this.isShared = false,
  });

  void update(BoxModel model){
    this.name = model.name;
    this.tags = model.tags;
    this.description = model.description;
    this.locationId = model.locationId;
    this.description = model.description;
    this.imagePath = model.imagePath;
  }
}

// this is Model for item_management_view
@HiveType(typeId: 3)
class ItemModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String id;
  @HiveField(2)
  String? boxId;
  @HiveField(3)
  String? locationId;
  @HiveField(4)
  String description;
  @HiveField(5)
  String purchaseDate;
  @HiveField(6)
  String imagePath;
  @HiveField(7)
  double value;
  @HiveField(8)
  int quantity;
  @HiveField(9)
  String tags;

  ItemModel(
      { this.name="",
       this.id="",
       this.boxId="",
       this.locationId="",
       this.description="",
       this.purchaseDate="",
       this.imagePath="",
       this.value=0,
       this.quantity=1,
       this.tags=""});
}
