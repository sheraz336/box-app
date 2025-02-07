import 'package:flutter/material.dart';
import 'category_tab.dart';

class ManagementCategoryTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const ManagementCategoryTabs({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CategoryTab(
            iconPath: "assets/location.svg",
            text: "Location Management",
            color: Colors.amber[100]!,
            isSelected: selectedTab == "Management",
            onTap: () => onTabSelected("Management"),
          ),
          SizedBox(width: 8,),
          CategoryTab(
            iconPath: "assets/boxes.svg",
            text: "Boxes Management",
            color: Colors.purple.shade300,
            isSelected: selectedTab == "Boxes Management",
            onTap: () => onTabSelected("Boxes Management"),
          ),
          SizedBox(width: 8,),
          CategoryTab(
            iconPath: "assets/items.svg",
            text: "Item Management",
            color: Colors.green,
            isSelected: selectedTab == "Items",
            onTap: () => onTabSelected("Items"),
          ),
        ],
      ),
    );
  }
}
