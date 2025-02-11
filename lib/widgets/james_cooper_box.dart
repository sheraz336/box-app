import 'package:flutter/material.dart';
import '../models/box_model.dart';
import '../models/item_model.dart';

class StyledBoxCard extends StatelessWidget {
  final LocationModel box;
  final Function(String) onEdit;
  final Function(String) onDelete;

  const StyledBoxCard({
    Key? key,
    required this.box,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 159,
      height: 263,
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
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/final.png', // Path to your background image
              width: 165,
              height: 263,
              fit: BoxFit.cover, // Ensure the image covers the entire container
            ),
          ),
          // Gradient Overlay

          // Content
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
                padding: const EdgeInsets.only(left: 3),
                child: Container(
                  width: 141,
                  height: 94,
                  margin: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Image.asset(
                    box.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
                child: Container(
                  width: 141,
                  height: 81,
                  margin: const EdgeInsets.only(left: 9, top: 5),
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
                        Text(
                          'Boxes: ${box.boxes.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        Text(
                          'Items: ${box.items}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        Text(
                          'Value: £${box.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        if (false)
                          Text(
                            'Shared: Yes',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 167,
                height: 39,
                color: Color(0xffD9D9D9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/pen_edit.png',
                      width: 18.86,
                      height: 19.5,
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
