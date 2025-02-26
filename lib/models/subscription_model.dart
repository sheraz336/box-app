class SubscriptionModel {
  final int id;
  final String name;
  final double price;
  final int maxBoxes, maxLocations, maxItems;
  final bool isPremium;
  final Duration duration;

  SubscriptionModel(
      {required this.id,
      this.duration = const Duration(days: 1),
      required this.name,
      required this.price,
      required this.maxBoxes,
      required this.maxLocations,
      required this.maxItems,
      required this.isPremium});

  static SubscriptionModel getById(int idx) {
    switch (idx) {
      case 0:
        return Free;
      case 1:
        return Basic;
    }
    return Premium;
  }

  static SubscriptionModel get Free => SubscriptionModel(
      id: 0,
      name: "Free",
      isPremium: false,
      //25 boxes
      maxBoxes: 5 * 5,
      //125 items
      maxItems: (5 * 5) * 5,
      maxLocations: 5,
      price: 0);

  static SubscriptionModel get Basic => SubscriptionModel(
      id: 1,
      name: "Basic",
      isPremium: false,
      //100 boxes
      maxBoxes: 10 * 10,
      //1000 items
      maxItems: (10 * 10) * 10,
      maxLocations: 10,
      price: 100);

  static SubscriptionModel get Premium => SubscriptionModel(
      id: 2,
      name: "Premium",
      isPremium: true,
      duration: Duration(days: 365),
      maxBoxes: 9999999999999999,
      maxItems: 9999999999999999,
      maxLocations: 9999999999999999,
      price: 200);
}
