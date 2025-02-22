import 'dart:io';

import 'package:box_delivery_app/models/item_model.dart';
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

void showQrPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return QrPopupContainer(
        onPrint: () {
          Navigator.pop(context);
        },
        onDone: () {
          Navigator.pop(context);
        },
      );
    },
  );
}

class _AddBoxViewState extends State<AddBoxView> {
  String selectedTab = "Boxes";
  final _formKey = GlobalKey<FormState>();
  final AdManager _adManager = AdManager(); // Create an instance of AdManager

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

      await controller.addBox(); // Ensure action completes first

      // Show AdMob Interstitial Ad after every 3 times a box is added
      _adManager.incrementBoxCount(() {
        if (mounted) {
          Navigator.pop(context); // Only pop after ad is closed
        }
      });
    } catch (e) {
      print(e);
      showSnackbar(context, e.toString());
    }
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
                    const Text("Upload Photo (Optional)",
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: ()async{
                        try{
                          final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(image==null)return;
                          setState(() {
                            controller.imageUrl=image.path;
                          });
                        }catch(e){
                          print(e);
                          showSnackbar(context, e.toString());
                        }
                      },
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
                              : Image.file(File(controller.imageUrl!),
                              fit: BoxFit.cover),
                        ),
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
              ));
        },
      ),
    );
  }
}
