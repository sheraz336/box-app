import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/location_mang_controller.dart';
import '../widgets/location_manangement.dart';
import '../widgets/management_category_tabs.dart';
import '../widgets/share_location_dialoge.dart';

class LocationManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Location Management",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xffe25e00),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ManagementCategoryTabs(
                    onTabSelected: (tab) {
                      provider.setSelectedTab(tab);
                      print("sjdlfsjdf $tab");

                      if (tab == "Items") {
                        Navigator.pushNamed(context, "/manage_items");
                      } else if (tab == "Boxes Management") {
                        Navigator.pushNamed(context, "/manage_boxes");
                      } else {
                        Navigator.pushNamed(context, "/manage_location");
                      }
                    },
                    selectedTab: '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/edit_location");
                          },
                          child: StyledBoxCard(
                            box: provider.boxes[0],
                            onEdit: provider.editBox,
                            onDelete: provider.deleteBox,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ShareLocationDialog(),
                            );
                          },
                          child: StyledBoxCard(
                            box: provider.boxes[1],
                            onEdit: provider.editBox,
                            onDelete: provider.deleteBox,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ShareLocationDialog(),
                            );
                          },
                          child: StyledBoxCard(
                            box: provider.boxes[0],
                            onEdit: provider.editBox,
                            onDelete: provider.deleteBox,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ShareLocationDialog(),
                            );
                          },
                          child: StyledBoxCard(
                            box: provider.boxes[1],
                            onEdit: provider.editBox,
                            onDelete: provider.deleteBox,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
