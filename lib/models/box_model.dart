
class Box_Model {
  final String title;
  final String imageUrl;
  final int itemCount;

  Box_Model({required this.title, required this.imageUrl, required this.itemCount});
}

class Item_Model {
  final String name;
  final String id;
  final String purchaseDate;
  final String imageUrl;

  Item_Model({required this.name, required this.id, required this.purchaseDate, required this.imageUrl});
}
