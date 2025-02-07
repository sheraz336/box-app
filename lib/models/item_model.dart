// this model is for home_screen.dart
class BoxModel {
  final String id;
  final String name;
  final String imagePath;
  final int items;
  final double value;
  final bool isShared;
  final bool hasTimer;
  final String? locationName;

  BoxModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.items,
    required this.value,
    this.isShared = false,
    this.hasTimer = false,
    this.locationName,
  });
}
// this is Model for item_management_view
class ItemModel {
  final String name;
  final String id;
  final dynamic purchaseDate;
  final String imagePath;
  final double? value;

  ItemModel({
    required this.name,
    required this.id,
    required this.purchaseDate,
    required this.imagePath,
    this.value,
  });
}
