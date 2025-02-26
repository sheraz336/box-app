import 'dart:io';
import 'package:flutter/material.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScale = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: onView, // Tap anywhere to view details
      child: Container(
        width: screenWidth * 0.42, // Scales width dynamically (42% of screen)
        height: screenHeight * 0.22, // Scales height dynamically (22% of screen)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // Adjust radius based on screen width
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
            // Background Image
            /*Positioned(
              top: 0,
              left: -3,
              right: -3,
              child: Container(
                decoration:BoxDecoration(
                  color:Colors.green,
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.04),
                  topRight: Radius.circular(screenWidth * 0.04),
                ),
                ),
                /*child: Image.asset(
                  'assets/final_gadget.png',
                  width: screenWidth * 0.44, // Adjust image width
                  height: screenHeight * 0.23, // Adjust image height
                  fit: BoxFit.fill,
                ),*/
              ),
            ),
*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


    Container(
      width: double.infinity,
    decoration:BoxDecoration(
    color:Colors.lightGreenAccent,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(screenWidth * 0.04),
    topRight: Radius.circular(screenWidth * 0.04),
    ),
    ),
    child:Padding(
                  padding: EdgeInsets.all(screenWidth * 0.015),
                  child: Center(
                    child: Text(
                      box.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14 * textScale, // Adjust font size dynamically
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
    ),

                SizedBox(height: screenHeight*0.008,),
                // Inner Box Image
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.33, // Adjust width dynamically
                      height: screenHeight * 0.10, // Adjust height dynamically
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.1),
                      ),
                      child: box.imagePath != null
                          ? Image.file(File(box.imagePath!), fit: BoxFit.cover)
                          : Image.asset("assets/box.png", fit: BoxFit.cover),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only( top: screenHeight * 0.01),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.33, // Adjust width dynamically
                      height: screenHeight * 0.04, // Adjust height dynamically
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Items: ${box.items}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5 * textScale, // Adjust font size dynamically
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //SizedBox(height: screenHeight * 0.010),
                Spacer(),

                // Bottom Actions
                Container(
                  width: screenWidth * 0.48, // Adjust width dynamically
                  height: screenHeight * 0.059, // Adjust height dynamically
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenWidth * 0.03),
                      bottomRight: Radius.circular(screenWidth * 0.03),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Image.asset(
                          'assets/pen_edit.png',
                          width: screenWidth * 0.05, // Adjust size dynamically
                          height: screenHeight * 0.025, // Adjust size dynamically
                        ),
                      ),
                      Container(
                        width: 1,
                        height: screenHeight * 0.04,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Image.asset(
                          'assets/delete_box.png',
                          width: screenWidth * 0.05, // Adjust size dynamically
                          height: screenHeight * 0.025, // Adjust size dynamically
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
}
