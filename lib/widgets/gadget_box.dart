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
    return Container(
      width: 161,
      height: 192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/final_gadget.png',
              width: 165,
              height: 192,
              fit: BoxFit.cover,
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
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
                      ? Image.file(File(box.imagePath!))
                      : Image.asset(
                    "assets/box.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Container(
                  width: 125,
                  height: 26.31,
                  decoration: BoxDecoration(
                    color: Color(0xffFCFCFC).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Items: ${box.items}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11.5,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 11.3),
              Container(
                width: 168,
                height: 38,
                color: Color(0xffD9D9D9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/pen_edit.png',
                      width: 24.46,
                      height: 24,
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: Colors.black,
                    ),
                    Image.asset(
                      'assets/delete_box.png',
                      width: 18.86,
                      height: 19.5,
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
