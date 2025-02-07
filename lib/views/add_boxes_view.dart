import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../controllers/addbox_controller.dart';
import '../widgets/category_tabs.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/qr_popup_container.dart';

class AddBoxView extends StatefulWidget {
  @override
  State<AddBoxView> createState() => _AddBoxViewState();
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

class _AddBoxViewState extends State<AddBoxView> {
  String selectedTab = "Boxes";

  void navigateTo(String tab) {
    if (tab != selectedTab) {
      setState(() => selectedTab = tab);

      if (tab == "Location") {
        Navigator.pushNamed(context, "/add_location");
      } else if (tab == "Boxes") {
        Navigator.pushNamed(context, "/add_box");
      } else if (tab == "Items") {
        Navigator.pushNamed(context, "/items");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddBoxController(),
      child: Consumer<AddBoxController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add Box"),
              backgroundColor: Color(0xffe25e00),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryTabs(selectedTab: selectedTab, onTabSelected: navigateTo),

                  SizedBox(height: 16),

                  const Text("Upload Photo (Optional)", style: TextStyle(color: Colors.grey)),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(Icons.add, size: 50, color: Colors.black26),
                    ),
                  ),

                  SizedBox(height: 16),

                  CustomTextField(
                    controller: controller.boxNameController,
                    labelText: "Box Name",
                    hintText: "Enter box name",
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.locationController,
                    labelText: "Location",
                    hintText: "Enter location",
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: "Description",
                    hintText: "Enter description",
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.tagsController,
                    labelText: "Tags (Optional)",
                    hintText: "Enter tags",
                  ),

                  SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: controller.generateQrCode,
                        onChanged: (value) => controller.toggleQrCode(),
                      ),
                      Text("Generate QR Code (Optional)"),
                    ],
                  ),
                  Container(
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

                  SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addBox;
                        showQrPopup(context);
                      },
                      child: Text("Add Box"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe25e00),
                        padding: EdgeInsets.all(14),
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
