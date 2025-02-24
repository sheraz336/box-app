import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class StyledBoxCard extends StatelessWidget {
  final LocationModel box;
  final Function() onEdit;
  final Function() onDelete,onShare,onView;

  const StyledBoxCard({
    Key? key,
    required this.onView,
    required this.box,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onView,
      child: Container(
        width: screenWidth * 0.42, // Responsive width
        height: screenHeight * 0.325, // Responsive height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xffFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Softer shadow
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 3), // Natural shadow positioning
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/final.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(screenWidth * 0.022),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          box.name,
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(onTap: onShare, child: Icon(Icons.share,color: Colors.white,size: 16,))
                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: box.imagePath != null
                        ? Image.file(File(box.imagePath!), fit: BoxFit.cover)
                        : Image.asset("assets/box.png", fit: BoxFit.cover),
                  ),
                ),
                SizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.010),
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.09,
                    decoration: BoxDecoration(
                      color: Color(0xffFCFCFC).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _detailText('Boxes: ${box.boxes.length}', screenWidth),
                          _detailText('Items: ${box.items}', screenWidth),
                          _detailText('Value: £${box.value}', screenWidth),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10), ), // Slightly rounded for smoothness
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Image.asset(
                          'assets/pen_edit.png',
                          width: screenWidth * 0.05,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: screenHeight * 0.03,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Image.asset(
                          'assets/delete_box.png',
                          width: screenWidth * 0.05,
                        ),
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

  Text _detailText(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.032,
        color: Color(0xff4D4D4D),
      ),
    );
  }
}
