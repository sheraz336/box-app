import 'package:flutter/material.dart';
import 'category_tab.dart';

class CategoryTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const CategoryTabs({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryTab(
          iconPath: "assets/location.svg",
          text: "Location",
          color: Color(0xffe25e00),
          isSelected: selectedTab == "Location",
          onTap: () => onTabSelected("Location"),
        ),
        CategoryTab(
          iconPath: "assets/boxes.svg",
          text: "Boxes",
          color: Colors.purple,
          isSelected: selectedTab == "Boxes",
          onTap: () => onTabSelected("Boxes"),
        ),
        CategoryTab(
          iconPath: "assets/items.svg",
          text: "Items",
          color: Colors.green,
          isSelected: selectedTab == "Items",
          onTap: () => onTabSelected("Items"),
        ),
      ],
    );
  }
}
