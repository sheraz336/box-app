import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class BoxCard extends StatelessWidget {
  final BoxModel box;
  final Function() onEdit;
  final Function() onDelete;

  const BoxCard({
    Key? key,
    required this.box,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: 161, // Fixed width
      height: 192, // Fixed height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), // Only top edges are rounded
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
          /* Positioned(
            top: 0,
            left: -3,
            right: -3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ), // Rounded only at the top
              child: Image.asset(
                'assets/final_gadget.png',
                width: 170,
                height: 195,
                fit: BoxFit.fill,
              ),
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
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    box.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ),
              SizedBox(height: screenHeight*0.008,),
              // Inner Box Image
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Center(
                  child: Container(
                    width: 122.64,
                    height: 69.2,
                    margin: const EdgeInsets.symmetric(horizontal: 9),
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
                padding: const EdgeInsets.only(left: 0, top: 10),
                child: Center(
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
              ),

              Spacer(),

              // Bottom Actions
              Container(
                width: 168,
                height: 39.2,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10), ), // Slightly rounded for smoothness
                ),
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
    );
  }
}
