import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:box_delivery_app/widgets/custom_textform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShareLocationDialog extends StatefulWidget {
  final Function(String, String) onUserSelected;

  const ShareLocationDialog({super.key, required this.onUserSelected});

  @override
  State<ShareLocationDialog> createState() => _ShareLocationDialogState();
}

class _ShareLocationDialogState extends State<ShareLocationDialog> {
  List<Map<String, Object?>> users = [], filteredUsers = [];
  Map<String, Object?>? selectedUser;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();
      users =
          snapshot.docs.map((item) => {...item.data(), "id": item.id}).toList();
      filteredUsers = users;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void filter(String searchText) {
    filteredUsers = users.where((item) {
      final inName = (item["name"] as String)
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final inEmail = (item["name"] as String)
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final inPhone = (item["name"] as String)
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return inPhone || inEmail || inName;
    }).toList();
    setState(() {});
    print("filterrr");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Share Location",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff484848),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hintText: 'Enter Email/Name to Search User',
              controller: controller,
              onChanged: filter,
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xffCFD5DB)),
            ),
            SizedBox(height: 0.1),
            Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...filteredUsers.map((item) => GestureDetector(
                            onTap: () {
                              selectedUser = item;
                              controller.text = item["name"] as String;
                              filter(controller.text);
                            },
                            child: _buildEmailTile(item["name"] as String),
                          )),
                      // _buildEmailTile("WadeWarren@gmail.com", isSelected: true),
                      // _buildEmailTile(
                      //   "EstherHoward@gmail.com",
                      // ),
                      // _buildEmailTile("RonaldRichards@gmail.com"),
                    ],
                  ),
                )),
            SizedBox(height: 5),
            CustomButton(
                text: 'Send Invite',
                onPressed: () {
                  if (selectedUser == null) {
                    showSnackbar(context, "Select a user first");
                    return;
                  }
                  Navigator.pop(context);
                  widget.onUserSelected(selectedUser!["id"] as String,
                      selectedUser!["name"] as String);
                })
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTile(String email, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: isSelected ? 38 : 38, // Adjust height for selected email
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffFEF8E1) : Colors.transparent,
          borderRadius:
              BorderRadius.circular(4), // Rounded corners for selected email
        ),
        child: Center(
          // Center the text vertically
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              email,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff484848),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
