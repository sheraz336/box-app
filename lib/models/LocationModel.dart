// models/location_model.dart
class LocationModel {
  String name;
  String address;
  String type;
  String? description;
  String? imageUrl;

  LocationModel({
    required this.name,
    required this.address,
    required this.type,
    this.description,
    this.imageUrl,
  });
}
