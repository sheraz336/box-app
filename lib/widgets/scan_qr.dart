import 'package:box_delivery_app/models/item_model.dart';
import 'package:flutter/material.dart';
class BoxDetailsDialog {
  // Method to show the details dialog
  static void showDetailsDialog(BuildContext context, BoxModel box) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Scan QR Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // QR Code Image
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    "assets/QR.png", // Replace with your QR code asset
                    height: 150,
                    width: 150,
                  ),
                ),
                SizedBox(height: 0.5),
                _build(context,box),
                SizedBox(height: 16),
                Image.asset(
                  'assets/bar_code.png',
                  height: 69,
                  width: 110,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: "Print PDF",
                      backgroundColor: Colors.white,
                      textColor: Color(0xff06a3e0),
                      borderColor: Color(0xFF06a3e0),
                      onPressed: () {
                        // Print PDF logic here
                      },
                    ),
                    SizedBox(width: 10), // Gap between buttons
                    _buildButton(
                      text: "Download PDF",
                      backgroundColor: Color(0xFF06a3e0),
                      textColor: Color(0xffFFFFFF),
                      borderColor: Color(0xFF06a3e0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build a detail row
  static Widget _buildDetailRow(String label, String value) {
    return Container(
      width: 332, // Width of each row
      height: 32, // Height of each row
      padding: EdgeInsets.symmetric(horizontal: 12), // Horizontal padding
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffD9D9D9)), // Bottom border
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xff21252C),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xffBABFC5),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the details container
  static Widget _build(BuildContext context,BoxModel box) {
    return Container(
      width: 332, // Overall width
      height: 130, // Overall height
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        border: Border.all(color: Color(0xffD9D9D9)), // Border color
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Column(
        children: [
          _buildDetailRow("Box ID", box.id),
          _buildDetailRow("Location", box.location?.name ?? "none"),
          _buildDetailRow("Description", box.description),
          _buildDetailRow("Tags",box.tags),
        ],
      ),
    );
  }

  // Helper method to build a button
  static Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 145, // Fixed width for the button
      height: 56, // Fixed height
      decoration: BoxDecoration(
        color: backgroundColor, // Background color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor, // Border color
          width: 1,
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // No extra padding
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor, // Text color
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}