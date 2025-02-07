import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QrPopupContainer extends StatelessWidget {
  final VoidCallback onPrint;
  final VoidCallback onDone;

  const QrPopupContainer({
    Key? key,
    required this.onPrint,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Added Successfully" Text
          const Text(
            "Added Successfully",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 50),

          // Print & Done Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Print Button
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrint,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xffe25e00)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Print",
                    style: TextStyle(color: Color(0xffe25e00), fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Done Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe25e00),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Done", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
