import 'package:flutter/material.dart';

class EditItemScreen extends StatefulWidget {
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Item", style: TextStyle(color: Colors.white)),
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
            // Item ID Field
            Text("Item ID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextField(
              controller: _itemIdController,
              decoration: InputDecoration(
                hintText: "Enter Item ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),

            // Box Dropdown
            Text("Box", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                  value: selectedBox,
                  hint: Text("Select your Box"),
                  items: ["Gadget Box", "Electronics Kit", "Tool Box"]
                      .map((box) => DropdownMenuItem(
                    value: box,
                    child: Text(box),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBox = value;
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
                  print("Item ID: ${_itemIdController.text}");
                  print("Box: $selectedBox");
                  print("Description: ${_descriptionController.text}");
                },
                child: Text("Update Item", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
