import 'package:flutter/material.dart';

class EditLocationScreen extends StatefulWidget {
  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String locationName = '';
  String address = '';
  String selectedType = 'Select Type';
  String selectedLatitude = 'Select';
  String selectedLongitude = 'Select';
  String description = '';

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
              _buildTextField('Enter Current Location', (value) {
                setState(() {
                  locationName = value;
                });
              }),
              _buildLabel('Address'),
              _buildTextField('Enter Address', (value) {
                setState(() {
                  address = value;
                });
              }),
              _buildLabel('Type'),
              _buildDropdown(['Select Type', 'Home', 'Office', 'Other'],
                  (value) {
                setState(() {
                  selectedType = value!;
                });
              }),
              _buildLabel('Enter Latitude'),
              _buildDropdown(['Select', '12.34', '56.78'], (value) {
                setState(() {
                  selectedLatitude = value!;
                });
              }),
              _buildLabel('Enter Longitude'),
              _buildDropdown(['Select', '98.76', '54.32'], (value) {
                setState(() {
                  selectedLongitude = value!;
                });
              }),
              _buildLabel('Description'),
              _buildTextField(
                'Enter Description',
                (value) {
                  setState(() {
                    description = value;
                  });
                },
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Process the data
                      print('Location updated');
                    }
                  },
                  child: Text(
                    'Update Location',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
      {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      maxLines: maxLines, // Adjust height if needed
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Fix spacing
      ),
      value: options.first,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
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
