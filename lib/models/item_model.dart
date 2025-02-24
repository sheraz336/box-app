// this model is for home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';

part 'item_model.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  String locationId;
  @HiveField(1)
  String name;
  @HiveField(2)
  String address;
  @HiveField(3)
  String type;
  @HiveField(4)
  String description;
  @HiveField(5)
  String? imagePath;
  @HiveField(6)
  String? ownerId;

  int items = 0;
  List<BoxModel> boxes = [];
  double value = 0;

  LocationModel(
      {required this.locationId,
      this.ownerId,
      required this.name,
      required this.address,
      required this.type,
      required this.description,
      required this.imagePath});

  void update(LocationModel model) {
    this.name = model.name;
    this.address = model.address;
    this.type = model.address;
    this.type = model.type;
    this.description = model.description;
    this.imagePath = model.imagePath;
  }

  LocationModel copy() {
    return LocationModel(
        ownerId: ownerId,
        locationId: locationId,
        name: name,
        address: address,
        type: type,
        description: description,
        imagePath: imagePath)
      ..boxes = boxes
      ..items = items
      ..value = value;
  }

  bool isShared() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null && uid != ownerId;
  }


  static LocationModel fromMap(Map map) {
    return LocationModel(
        ownerId: map["ownerId"],
        locationId: map["locationId"],
        name: map["name"],
        address: map["address"],
        type: map["type"],
        description: map["description"],
        imagePath: map["imagePath"]);
  }

  Map<String, Object?> toMap() {
    return {
      "ownerId": ownerId,
      "locationId": locationId,
      "name": name,
      "address": address,
      "type": type,
      "description": description,
      "imagePath": imagePath
    };
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
  String? imagePath;
  @HiveField(5)
  String? locationId;
  @HiveField(6)
  String? ownerId;

  LocationModel? location;
  int items;
  double value;

  BoxModel({
    this.ownerId,
    this.locationId,
    required this.tags,
    required this.description,
    required this.id,
    required this.name,
    required this.imagePath,
    //
    this.location,
    this.items = 0,
    this.value = 0,
  });

  void update(BoxModel model) {
    this.name = model.name;
    this.tags = model.tags;
    this.description = model.description;
    this.locationId = model.locationId;
    this.description = model.description;
    this.imagePath = model.imagePath;
  }

  bool isShared() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null && uid != ownerId;
  }

  static BoxModel fromMap(Map map) {
    print("map ${map}");
    return BoxModel(
        value: map["value"],
        ownerId: map["ownerId"],
        locationId: map["locationId"],
        tags: map["tags"],
        description: map["description"],
        id: map["id"],
        name: map["name"],
        imagePath: map["imagePath"]);
  }

  Map<String, Object?> toMap() {
    return {
      "value": value,
      "ownerId": ownerId,
      "locationId": locationId,
      "tags": tags,
      "description": description,
      "id": id,
      "name": name,
      "imagePath": imagePath
    };
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
  String? imagePath;
  @HiveField(7)
  double value;
  @HiveField(8)
  int quantity;
  @HiveField(9)
  String tags;
  @HiveField(10)
  String? ownerId;
  @HiveField(11)
  String? boxLocationId; // location of the box it belongs to

  ItemModel(
      {this.name = "",
      this.id = "",
      this.ownerId,
      this.boxId,
      this.locationId,
      this.description = "",
      this.purchaseDate = "",
      this.imagePath,
      this.value = 0,
      this.quantity = 1,
      this.boxLocationId,
      this.tags = ""});

  bool isShared() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null && uid != ownerId;
  }


  static ItemModel fromMap(Map map) {
    return ItemModel(
        name: map["name"],
        id: map["id"],
        ownerId: map["ownerId"],
        boxId: map["boxId"],
        locationId: map["locationId"],
        boxLocationId: map["boxLocationId"],
        description: map["description"],
        purchaseDate: map["purchaseDate"],
        value: map["value"],
        tags: map["tags"],
        imagePath: map["imagePath"],
        quantity: map["quantity"]);
  }

  Map<String, Object?> toMap() {
    return {
      "name": name,
      "id": id,
      "ownerId": ownerId,
      "boxId": boxId,
      "locationId": locationId,
      "boxLocationId": boxLocationId,
      "description": description,
      "purchaseDate": purchaseDate,
      "value": value,
      "tags": tags,
      "imagePath": imagePath,
      "quantity": quantity
    };
  }
}
