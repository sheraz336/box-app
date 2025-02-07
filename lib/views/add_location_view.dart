import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/add_location_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/category_tabs.dart';
import '../widgets/qr_popup_container.dart';

class AddLocationView extends StatefulWidget {
  @override
  State<AddLocationView> createState() => _AddLocationViewState();
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

class _AddLocationViewState extends State<AddLocationView> {
  String selectedTab = "Location"; // 👈 Default selected tab

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
      create: (context) => AddLocationController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Location", style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xffe25e00),
        ),
        body: Consumer<AddLocationController>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tabs
                  CategoryTabs(selectedTab: selectedTab, onTabSelected: navigateTo),

                  const SizedBox(height: 12),

                  // Upload Photo
                  const Text("Upload Photo (Optional)", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    //onTap: () => controller.pickImage(), // Implement image picker
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: controller.imageUrl == null
                            ? SvgPicture.asset("assets/camera.svg", height: 40)
                            : Image.file(controller.imageUrl! as File, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location Name
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: "Location Name",
                    hintText: "Enter Current Location",
                    iconPath: "assets/camera.svg",
                  ),

                  const SizedBox(height: 16),

                  // Address
                  CustomTextField(
                    controller: controller.addressController,
                    labelText: "Address",
                    hintText: "Enter Address",
                  ),

                  const SizedBox(height: 16),

                  // Type Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedType,
                    decoration: InputDecoration(
                      labelText: "Type",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: ["Home", "Office", "Warehouse"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectType(newValue);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: "Description (Optional)",
                    hintText: "Enter Description",
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),

                  // Add Location Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveLocation();
                        showQrPopup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe25e00),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Add Location", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
