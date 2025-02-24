import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/qr_model.dart';
import '../../repos/box_repository.dart';

class EditItemScreen extends StatefulWidget {
  final ItemModel item;

  const EditItemScreen({super.key, required this.item});
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  BoxModel? selectedBox;

  @override
  void initState() {
    super.initState();
    final itemToEdit = widget.item;
    _itemIdController.text=itemToEdit.id;
    _descriptionController.text = itemToEdit.description;
  }

  void onUpdate()async{
    try{
      final description = _descriptionController.text.toString();
      await ItemRepository.instance.updateItem(widget.item..description=description);
      if(mounted)showSnackbar(context, "Successfully Updated");
    }catch(e){
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxes = context.watch<BoxRepository>().list;

    final itemToEdit = widget.item;
    if(selectedBox == null)selectedBox=BoxRepository.instance.getBox(itemToEdit.boxId);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item ID Field
              Text("Item ID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextField(
                controller: _itemIdController,
                enabled: false,
                decoration: InputDecoration(
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
                  child: DropdownButton<BoxModel>(
                    isExpanded: true,
                    value: selectedBox,
                    hint: Text("Select your Box"),
                    items: boxes
                        .map((box) => DropdownMenuItem(
                      value: box,
                      child: Text(box.name),
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
                maxLength: 100,
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
                  onPressed: onUpdate,
                  child: Text("Update Item", style: TextStyle(fontSize: 16, color: Colors.white)),
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
                  onPressed: ()=>showQrPopup(context,QrModel(type: ObjectType.Item,item: itemToEdit)),
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
}
