class LocationManagement {
  final String id;
  final String name;
  final String imagePath;
  final int items;
  final double value;
  final bool isShared;
  LocationManagement({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.items,
    required this.value,
    this.isShared = false,
  });
}
