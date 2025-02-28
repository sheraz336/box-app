import 'dart:io';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/add_location_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/qr_popup_container.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/ad_manager.dart';
 // Import AdManager class

class AddLocationView extends StatefulWidget {
  @override
  State<AddLocationView> createState() => _AddLocationViewState();
}

class _AddLocationViewState extends State<AddLocationView> {
  String selectedTab = "Location";
  final _formKey = GlobalKey<FormState>();
  bool _isAdding = false;
  final AdManager _adManager = AdManager(); //
  String? _imageError; // Track image validation error

  @override
  void initState() {
    super.initState();
    _adManager.loadAd();
  }

  void onSave(AddLocationController controller) async {
    try {
      if (_isAdding || !_formKey.currentState!.validate()) return;
      setState(() {
        _imageError = controller.imageUrl == null ? "Photo is required" : null;
      });
      if(_imageError != null)return;

      _isAdding=true;
      await controller.saveLocation();
      _isAdding=false;
      _adManager.incrementLocationCount(() {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      print(e);
      _isAdding=false;
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddLocationController(),
      child: Consumer<AddLocationController>(
        builder: (context, controller, child) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upload Photo (Required)",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        setState(() {
                          controller.imageUrl = image.path;
                          _imageError = null; // Clear error when image is selected
                        });
                      } catch (e) {
                        print(e);
                        showSnackbar(context, e.toString());
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: _imageError != null ? Colors.red : Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: controller.imageUrl == null
                            ? SvgPicture.asset("assets/camera.svg", height: 40)
                            : Image.file(File(controller.imageUrl!), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  if (_imageError != null) // Show error message if no image
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _imageError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    validator: Validators.locationValidator,
                    controller: controller.nameController,
                    labelText: "Location Name",
                    hintText: "Enter Current Location",
                    iconPath: "assets/add_camera.svg",
                    maxLength: 20,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    validator: Validators.addressValidator,
                    controller: controller.addressController,
                    labelText: "Address",
                    hintText: "Enter Address",
                    maxLength: 40,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    validator: (text) {
                      if (text == null) return "Location Type cannot be empty";
                      return null;
                    },
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
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: "Description (Optional)",
                    hintText: "Enter Description",
                    maxLines: 3,
                    maxLength: 100,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => onSave(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff06a3e0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Add Location", style: TextStyle(color: Colors.white, fontSize: 14)),
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
