import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/item_model.dart';

class BoxCard extends StatelessWidget {
  final BoxModel box;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const BoxCard({
    Key? key,
    required this.box,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView, // Tap anywhere to view details
      child: Container(
        width: 161, // Fixed width
        height: 192, // Fixed height
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ), // Only top edges are rounded
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image (Overflows slightly)
            Positioned(
              top: 0,
              left: -5,
              right: -5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ), // Rounded only at the top
                child: Image.asset(
                  'assets/final_gadget.png',
                  width: 170,
                  height: 195,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    box.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Inner Box Image
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 126.64,
                    height: 77.14,
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.1),
                    ),
                    child: box.imagePath != null
                        ? Image.file(File(box.imagePath!), fit: BoxFit.cover)
                        : Image.asset("assets/box.png", fit: BoxFit.cover),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    width: 125,
                    height: 26.31,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4), // Slightly rounded for smoothness
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Items: ${box.items}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 23),

                // Bottom Actions
                Container(
                  width: 168,
                  height: 38,
                  color: const Color(0xffD9D9D9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Image.asset('assets/pen_edit.png', width: 18.86,
                          height: 19.5,),
                      ),
                      Container(width: 1, height: 28, color: Colors.black),
                      GestureDetector(
                        onTap: onDelete,
                        child: Image.asset('assets/delete_box.png', width: 20, height: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
