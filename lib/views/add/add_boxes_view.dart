import 'dart:io';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/models/qr_model.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controllers/addbox_controller.dart';
import '../../repos/location_repository.dart';
import '../../widgets/category_tabs.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/qr_popup_container.dart';
import '../admob/ad_manager.dart';

class AddBoxView extends StatefulWidget {
  @override
  State<AddBoxView> createState() => _AddBoxViewState();
}


class _AddBoxViewState extends State<AddBoxView> {
  String selectedTab = "Boxes";
  final _formKey = GlobalKey<FormState>();
  final AdManager _adManager = AdManager(); // Create an instance of AdManager
  String? _imageError; //
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    _adManager.loadAd(); // Load the ad when the screen initializes
  }

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

  void onSave(AddBoxController controller) async {
    try {
      if (!_formKey.currentState!.validate()) return;
      setState(() {
        _imageError = controller.imageUrl == null ? "Photo is required" : null;
      });
      if(_imageError == null)return;
      final box  = await controller.addBox(); // Ensure action completes first

      // Show AdMob Interstitial Ad after every 3 times a box is added
      _adManager.incrementBoxCount(() {
        if (mounted) {
          if(controller.generateQrCode){
            showQrPopup(context, QrModel(type: ObjectType.Box,box:box ));
            showSnackbar(context, "Box added successfully");
            return;
          }
          Navigator.pop(context); // Only pop after ad is closed
        }
      });
    } catch (e) {
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  /// Show Bottom Sheet for Image Selection
  void _showImagePicker(AddBoxController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Take a Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      controller.imageUrl = image.path;
                      _imageError = null;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.green),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      controller.imageUrl = image.path;
                      _imageError = null;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final locations = context.read<LocationRepository>().list;
    return ChangeNotifierProvider(
      create: (_) => AddBoxController(),
      child: Consumer<AddBoxController>(
        builder: (context, controller, child) {
          return Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload Photo (Required)",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => _showImagePicker(controller),
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
                    if (_imageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _imageError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
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
                    SizedBox(height: 16),
                    CustomTextField(
                      validator: Validators.boxNameValidator,
                      controller: controller.boxNameController,
                      labelText: "Box Name",
                      hintText: "Enter box name",
                      maxLength: 30,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<LocationModel>(
                      items: [
                        ...locations.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        })
                      ],
                      onChanged: (item) {
                        controller.locationId = item?.locationId;
                      },
                      hint: Text("Location"),
                      decoration: TextFieldInputDecoration,
                    ),
                    // CustomTextField(
                    //   controller: controller.locationController,
                    //   labelText: "Location",
                    //   hintText: "Enter location",
                    // ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.descriptionController,
                      labelText: "Description",
                      hintText: "Enter description",
                      maxLines: 3,
                      maxLength: 100,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      validator: Validators.tagsValidator,
                      controller: controller.tagsController,
                      labelText: "Tags (Optional)",
                      hintText: "Enter tags separated by comma",
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
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/QR.png",
                          height: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()=>onSave(controller),
                        child: Text("Add Box"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff06a3e0),
                          padding: EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
