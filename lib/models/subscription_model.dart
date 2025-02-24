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
      maxBoxes: 5 * 5,
      //5 box per location
      maxItems: (5 * 5) * 5,
      //5 items per box
      maxLocations: 5,
      price: 0);

  static SubscriptionModel get Basic => SubscriptionModel(
      id: 1,
      name: "Basic",
      isPremium: false,
      maxBoxes: 10 * 10,
      //10 boxes per location
      maxItems: (10 * 10) * 10,
      //10 items per box
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
