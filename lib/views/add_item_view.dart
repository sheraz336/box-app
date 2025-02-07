import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../controllers/add_item_controller.dart';
import '../widgets/category_tab.dart';
import '../widgets/category_tabs.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/qr_popup_container.dart';

class AddItemsView extends StatefulWidget {
  @override
  State<AddItemsView> createState() => _AddItemsViewState();
}

void showQrPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return QrPopupContainer(
        onPrint: () {
          // Handle Print button logic
          Navigator.pop(context);
        },
        onDone: () {
          // Handle Done button logic
          Navigator.pop(context);
        },
      );
    },
  );
}


class _AddItemsViewState extends State<AddItemsView> {
  String selectedTab = "Items";

  void navigateTo(String tab) {
    if (tab != selectedTab) {
      setState(() => selectedTab = tab);

      if (tab == "Location") {
        Navigator.pushNamed(context, "/add_location");
      } else if (tab == "Boxes") {
        Navigator.pushNamed(context, "/add_box");
      } else if (tab == "Items") {
        Navigator.pushNamed(context, "/add_items");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddItemsController(),
      child: Consumer<AddItemsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add Item"),
              backgroundColor: Color(0xffe25e00),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryTabs(selectedTab: "Items", onTabSelected: navigateTo),

                  const SizedBox(height: 16),

                  const Text("Upload Photo (Optional)", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {}, // Implement image picker
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.imageUrl == null
                          ? const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.black26))
                          : Image.asset(controller.imageUrl!, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: controller.itemNameController,
                    labelText: "Item Name",
                    hintText: "Enter item name",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.boxController,
                    labelText: "Select your Box",
                    hintText: "Choose a box",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: "Description",
                    hintText: "Enter description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.purchaseDateController,
                    labelText: "Purchase Date (Optional)",
                    hintText: "Enter purchase date",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.valueController,
                    labelText: "Value (Optional)",
                    hintText: "Enter value",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.quantityController,
                    labelText: "Qty (Optional)",
                    hintText: "Enter quantity",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.tagsController,
                    labelText: "Tags (Optional)",
                    hintText: "Enter tags",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Text Field (Takes 3/4 width)
                      Expanded(
                        flex: 3,
                        child: CustomTextField(
                          controller: controller.qrBarcodeController,
                          labelText: "Scan QR/Barcode (Optional)",
                          hintText: "Scan or enter barcode",
                        ),
                      ),

                      SizedBox(width: 8), // Small spacing

                      // QR Icon (Takes 1/4 width)
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            // Implement QR scanning functionality here
                          },
                          child: Container(
                            height: 55, // Matches text field height
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent), // Grey border
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/QR.png", // Replace with your actual SVG path
                                height: 30, // Adjust size as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addItem;
                        showQrPopup(context);
                      },
                      child: const Text("Add Item"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe25e00),
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
