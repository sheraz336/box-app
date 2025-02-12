import 'dart:io';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoxCard extends StatelessWidget {
  final BoxModel box;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;

  const BoxCard(
      {Key? key,
      required this.box,
      required this.onViewDetails,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onViewDetails,
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                width: double.infinity,
                child: Text(
                  box.name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: box.imagePath != null
                    ? Image.file(File(box.imagePath!), height: 80, fit: BoxFit.cover)
                    : Image.asset(
                  "assets/box.png",
                    height: 80, fit: BoxFit.cover
                ),
              ),

              // Items Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Items: ${box.items}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: SvgPicture.asset("assets/edit.svg", height: 20),
                    ),
                    Container(
                        height: 12,
                        width: 1,
                        color: Colors.grey[500]), // Vertical Divider
                    IconButton(
                      onPressed: onDelete,
                      icon: SvgPicture.asset("assets/delete.svg", height: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
