import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:box_delivery_app/widgets/custom_textform.dart';
import 'package:flutter/material.dart';

class ShareLocationDialog extends StatelessWidget {
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
           CustomTextFormField(hintText: 'Enter Email to Search User', onChanged:debugPrint
        ,textStyle: TextStyle(
               fontWeight: FontWeight.w400,
               fontSize: 14,
               color: Color(0xffCFD5DB)
             ),   ),
            SizedBox(height: 0.1),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffD9D9D9)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildEmailTile("WadeWarren@gmail.com", isSelected: true),
                  _buildEmailTile("EstherHoward@gmail.com",),
                  _buildEmailTile("RonaldRichards@gmail.com"),
                ],
              ),
            ),
            SizedBox(height: 5),
          CustomButton(text: 'Send Invite', onPressed: (){

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
          borderRadius: BorderRadius.circular(4), // Rounded corners for selected email
        ),
        child: Center( // Center the text vertically
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