import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/location_repository.dart';


class EditBoxesScreen extends StatefulWidget {
  final BoxModel box;

  const EditBoxesScreen({super.key, required this.box});

  @override
  _EditBoxesScreenState createState() => _EditBoxesScreenState();
}

class _EditBoxesScreenState extends State<EditBoxesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _boxIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  LocationModel? selectedLocation;

  @override
  void initState() {
    super.initState();
    _boxIdController.text = widget.box.id;
    _descriptionController.text = widget.box.description;
    selectedLocation = widget.box.location;
  }

  onUpdateBox() async {
    try {
      if (!_formKey.currentState!.validate()) return;
      BoxRepository.instance.updateBox(widget.box
        ..location = selectedLocation
        ..description = _descriptionController.text);
      if (mounted) showSnackbar(context, "Box Updated Successfully");
    } catch (e) {
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationRepo = context.read<LocationRepository>();
    final locations = locationRepo.list;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Boxes", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff06a3e0),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Box ID Field
                Text("Box ID",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextFormField(
                  enabled: false,
                  controller: _boxIdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 20),

                // Location Dropdown
                Text("Location",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<LocationModel>(
                      isExpanded: true,
                      value: selectedLocation,
                      hint: Text("Select your Location"),
                      items: locations
                          .map((location) => DropdownMenuItem(
                                value: location,
                                child: Text(location.name),
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
                SizedBox(height: 20),

                // Description Field
                Text("Description",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 30),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff06a3e0),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onUpdateBox,
                    child: Text("Update Box",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
