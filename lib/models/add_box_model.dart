class AddBoxModel {
  String boxName;
  String location;
  String? description;
  List<String>? tags;
  String? imageUrl;
  bool generateQrCode;

  AddBoxModel({
    required this.boxName,
    required this.location,
    this.description,
    this.tags,
    this.imageUrl,
    this.generateQrCode = false,
  });
}
