class BoxModel {
  final String id;
  final String name;
  final String imagePath;
  final int items;
  final double? value;
  final bool isShared;

  BoxModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.items,
    this.value,
    required this.isShared,
  });
}
