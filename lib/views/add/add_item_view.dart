import 'dart:io';

import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/add_item_controller.dart';
import '../../models/item_model.dart';
import '../../repos/box_repository.dart';
import '../../repos/location_repository.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/qr_popup_container.dart';
import '../admob/ad_manager.dart';

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
          Navigator.pop(context);
        },
        onDone: () {
          Navigator.pop(context);
        },
      );
    },
  );
}

class _AddItemsViewState extends State<AddItemsView> {
  String selectedTab = "Items";
  final _formKey = GlobalKey<FormState>();
  final AdManager adManager = AdManager();
  int itemLimit = 10; // Default item limit

  @override
  void initState() {
    super.initState();
    adManager.loadRewardedAd();
  }

  void onAddItem(AddItemsController controller) {
   //if (controller.itemList.length >= itemLimit) {
    if (11 >= itemLimit) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Increase Item Limit"),
            content: const Text("Would you like to watch an ad to increase your item limit by 5?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSave(controller); // Proceed without ad
                },
                child: const Text("No", style: TextStyle(color: Colors.orange)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  adManager.showRewardedAd(() {
                    setState(() => itemLimit += 5);
                    onSave(controller);
                  });
                },
                child: const Text("Yes", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    } else {
      onSave(controller);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


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

  void onSave(AddItemsController controller)async{
    try{
      if(!_formKey.currentState!.validate())return;
      await controller.addItem();
      if(mounted)Navigator.pop(context);
    }catch(e){
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationRepository>().list;
    final boxes = context.watch<BoxRepository>().list;

    return ChangeNotifierProvider(
      create: (_) => AddItemsController(),
      child: Consumer<AddItemsController>(
        builder: (context, controller, child) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 16),
                  CustomTextField(
                    validator: Validators.itemNameValidator,
                    controller: controller.itemNameController,
                    labelText: "Item Name",
                    hintText: "Enter item name",
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  DropdownButtonFormField<BoxModel>(
                    items: [
                      ...boxes.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.name),
                          value: item,
                        );
                      })
                    ],
                    onChanged: (item) {
                      controller.boxId = item?.id;
                    },
                    hint: Text("Box"),
                    decoration: TextFieldInputDecoration,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: "Description",
                    hintText: "Enter description",
                    maxLines: 3,
                    maxLength: 100,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: ()async{
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        controller.purchaseDateController.text = DateFormat(DateFormat.YEAR_MONTH_DAY).format(pickedDate);
                      }
                    },
                    child: CustomTextField(
                      enabled: false,
                      controller: controller.purchaseDateController,
                      labelText: "Purchase Date (Optional)",
                      hintText: "Enter purchase date",
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    validator: Validators.valueValidator,
                    controller: controller.valueController,
                    labelText: "Value (Optional)",
                    hintText: "Enter value",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    validator: Validators.quantityValidator,
                    keyboardType: TextInputType.number,
                    controller: controller.quantityController,
                    labelText: "Qty (Optional)",
                    hintText: "Enter quantity",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    validator: Validators.tagsValidator,
                    controller: controller.tagsController,
                    labelText: "Tags (Optional)",
                    hintText: "Enter tags separated by comma",
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
                              border: Border.all(
                                  color: Colors.transparent), // Grey border
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/QR.png",
                                // Replace with your actual SVG path
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
                     // onPressed: ()=>onSave(controller),
                      onPressed: ()=>onAddItem(controller),
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
            ),);
        },
      ),
    );
  }
}
