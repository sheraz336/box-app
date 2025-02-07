import 'package:flutter/material.dart';
import '../widgets/box_card.dart';
import '../widgets/custom_delete_dailogue.dart';
import '../widgets/management_category_tabs.dart';
import '../models/box_model.dart';
import '../widgets/scan_qr.dart';


class BoxManagementScreen extends StatefulWidget {
  @override
  _BoxManagementScreenState createState() => _BoxManagementScreenState();
}

class _BoxManagementScreenState extends State<BoxManagementScreen> {
  String selectedTab = "Boxes";
  String? selectedLocation = "Select Location";

  void navigateTo(String tab) {
    if (tab != selectedTab) {
      setState(() => selectedTab = tab);

      if (tab == "Location") {
        Navigator.pushNamed(context, "/manage_location");
      } else if (tab == "Boxes") {
        Navigator.pushNamed(context, "/manage_boxes");
      } else if (tab == "Items") {
        Navigator.pushNamed(context, "/manage_items");
      }
    }
  }

  final List<Box_Model> boxes = List.generate(
    6,
        (index) => Box_Model(
      title: "Gadget Box",
      imageUrl: "assets/box.png",
      itemCount: 34,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Boxes", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffe25e00),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Scrollable Category Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ManagementCategoryTabs(
              selectedTab: selectedTab,
              onTabSelected: navigateTo,
            ),
          ),

          // Location Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedLocation,
                  items: ["Select Location", "Warehouse 1", "Warehouse 2"]
                      .map((location) => DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Grid of Box Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: boxes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return BoxCard(
                        box: boxes[index],
                        onEdit: () {
                          Navigator.pushNamed(context, "/edit_boxes");
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDeleteDialog(
                              onConfirm: () {
                                // Perform delete action
                                setState(() {
                                  boxes.removeAt(index); // Remove item from list
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },onViewDetails: () {
                        BoxDetailsDialog.showDetailsDialog(context, boxes[index]);
                      },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}