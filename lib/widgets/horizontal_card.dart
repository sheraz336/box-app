import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemHorizontalCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final DateTime? purchaseDate;
  final bool hasTimer;
  final VoidCallback? onEdit, onDelete;

  const ItemHorizontalCard({
    Key? key,
    this.onEdit,
    this.onDelete,
    required this.title,
    required this.imagePath,
    this.purchaseDate,
    this.hasTimer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 372.09,
      height: 87,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8)),
        border: Border.all(color: const Color(0xFFCFD5DB), width: 1),
      ),
      child: Row(
        children: [
          // Image Section
          Container(
            width: 117.93,
            height: 77,
            margin: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: imagePath != null
                ? Image.file(File(imagePath!))
                : Image.asset(
                    "assets/splashicon.png",
                    fit: BoxFit.cover,
                  ),
          ),
          // Text Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff353535),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Item ID
                  Row(
                    children: [
                      const Text(
                        "Item ID: ",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4D4D4D),
                        ),
                      ),
                      const Text(
                        "#3203JKL",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffABABAB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Purchase Date
                  if (purchaseDate != null)
                    Text(
                      'Purchase Date: ${DateFormat(DateFormat.YEAR_MONTH_DAY).format(purchaseDate!)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4D4D4D),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Timer Icon

          // Edit/Delete Section
          Column(
            children: [
              Container(
                width: 34.57,
                height: 85,
                decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Image.asset(
                        'assets/pen_edit.png',
                        width: 18.07,
                        height: 13.69,
                      ),
                    ),
                    Container(
                      width: 25.47,
                      height: 1.2,
                      color: Colors.black,
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: Image.asset(
                        'assets/delete_box.png',
                        width: 18.07,
                        height: 13.69,
                      ),
                    )
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
