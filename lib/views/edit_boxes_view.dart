import 'package:flutter/material.dart';

class EditBoxesScreen extends StatefulWidget {
  @override
  _EditBoxesScreenState createState() => _EditBoxesScreenState();
}

class _EditBoxesScreenState extends State<EditBoxesScreen> {
  final TextEditingController _boxIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Boxes", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffe25e00),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Box ID Field
            Text("Box ID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              controller: _boxIdController,
              decoration: InputDecoration(
                hintText: "Enter Box ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),

            // Location Dropdown
            Text("Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedLocation,
                  hint: Text("Select your Location"),
                  items: ["Warehouse 1", "Warehouse 2", "Warehouse 3"]
                      .map((location) => DropdownMenuItem(
                    value: location,
                    child: Text(location),
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
            Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 30),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffe25e00),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Handle update logic here
                  print("Box ID: ${_boxIdController.text}");
                  print("Location: $selectedLocation");
                  print("Description: ${_descriptionController.text}");
                },
                child: Text("Update Boxes", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
