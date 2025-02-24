import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/models/qr_model.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/location_repository.dart';
import '../../widgets/custom_textform.dart';
import '../../widgets/qr_popup_container.dart';

class EditLocationScreen extends StatefulWidget {
  final LocationModel location;

  const EditLocationScreen({super.key, required this.location});

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final LocationModel locationToEdit;
  @override
  void initState() {
    super.initState();
    locationToEdit = widget.location.copy();
  }

  onLocationUpdate() async {
    try {
      if(!_formKey.currentState!.validate())return;
      await LocationRepository.instance.updateLocation(locationToEdit);
      if (mounted) showSnackbar(context, "Location Updated Successfully");
    } catch (e) {
      print(e);
      showSnackbar(context, e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe25e00),
        elevation: 0,
        title: Text(
          'Edit Location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Location Name'),
              _buildTextField(
                "Location",
                (t) {
                  setState(() {
                    locationToEdit..name = t;
                  });
                },
                initialValue: locationToEdit.name,
                validator: Validators.locationValidator,
                maxLength: 20,
              ),
              _buildLabel('Address'),
              _buildTextField('Enter Address', (value) {
                setState(() {
                  locationToEdit..address = value;
                });
              },
                  initialValue: locationToEdit.address,
                  validator: Validators.addressValidator,
                  maxLength: 40),
              _buildLabel('Type'),

              _buildDropdown(
                ['Home', 'Office', 'Other'],
                locationToEdit.type,
                (String? value) {
                  setState(() {
                    locationToEdit..type = value!;
                  });
                },
              ),
              // _buildLabel('Enter Latitude'),
              // _buildTextField('Latitude', (value) {
              //   setState(() {
              //     locationToEdit..latitude = value;
              //   });
              // }),
              // _buildLabel('Enter Longitude'),
              // _buildTextField('Longitude', (value) {
              //   setState(() {
              //     locationToEdit..longitude = value;
              //   });
              // }),
              _buildLabel('Description'),
              _buildTextField(
                'Enter Description',
                (value) {
                  setState(() {
                    locationToEdit..description = value;
                  });
                },
                initialValue: locationToEdit.description,
                // validator: Validators.des,
                maxLength: 100,
                maxLines: 3, // Fix height of description field
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe25e00),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onLocationUpdate,
                  child: Text(
                    'Update Location',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //generate qr
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Color(0xffe25e00))
                    ),
                  ),
                  onPressed: ()=>showQrPopup(context,QrModel(type: ObjectType.Location,location: locationToEdit)),
                  child: Text(
                    'Generate QR',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffe25e00)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(String hintText, Function(String) onChanged,
      {int maxLines = 1,
      int? maxLength,
      String? initialValue,
      bool enabled = true,
      String? Function(String?)? validator}) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      maxLines: maxLines,
      // Adjust height if needed
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildDropdown<T>(List<T> options, T? value, Function(T?) onChanged) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Fix spacing
      ),
      value: value,
      items: options.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(
            (option is LocationModel) ? option.name : option.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: option == options.first
                  ? FontWeight.normal
                  : FontWeight.w500, // Fix bold issue
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value == options.first) {
          return 'Please select a value';
        }
        return null;
      },
    );
  }
}
