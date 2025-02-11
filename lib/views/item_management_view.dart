import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/item_controller.dart';
import '../widgets/management_category_tabs.dart';
import '../models/item_model.dart';
import '../widgets/nav_bar_widget.dart';


class ItemManagementScreen extends StatefulWidget {
  @override
  _ItemManagementScreenState createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  String selectedTab = "Items";
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemsController(),
      child: Consumer<ItemsController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Items", style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xffe25e00),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ManagementCategoryTabs(
                    selectedTab: selectedTab,
                    onTabSelected: navigateTo,
                  ),
                ),

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
                SizedBox(height: 1),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child:
                            ItemHorizontalCard(item: controller.items[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
          );
        },
      ),
    );
  }
}

class ItemHorizontalCard extends StatelessWidget {
  final ItemModel item;

  const ItemHorizontalCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/edit_items");
      },
      child: Container(
        width: 372.09,
        height: 87,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCFD5DB), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 117.93,
              height: 77,
              margin: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff353535),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          "Item ID: ",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        Text(
                          item.id,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffABABAB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Purchase Date: ${item.purchaseDate}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4D4D4D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 34.57,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/pen_edit.png',
                          width: 18.07, height: 13.69),
                      Container(
                        width: 25.47,
                        height: 1.2,
                        color: Colors.black,
                      ),
                      Image.asset('assets/delete_box.png',
                          width: 18.07, height: 13.69),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
