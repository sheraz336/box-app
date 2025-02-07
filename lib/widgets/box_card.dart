// widgets/box_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/box_model.dart';

class BoxCard extends StatelessWidget {
  final Box_Model box;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;

  const BoxCard({Key? key, required this.box,  required this.onViewDetails, required this.onEdit, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onViewDetails,
      child: Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green Header with Box Title
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            width: double.infinity,
            child: Text(
              box.title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Box Image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(box.imageUrl, height: 80, fit: BoxFit.cover),
          ),

          // Items Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Items: ${box.itemCount}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Edit and Delete Icons with Divider
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: SvgPicture.asset("assets/edit.svg", height: 20),
                ),
                Container(height: 12, width: 1, color: Colors.grey[500]), // Vertical Divider
                IconButton(
                  onPressed: onDelete,
                  icon: SvgPicture.asset("assets/delete.svg", height: 20),
                ),
              ],
            ),
          ),
        ],
      ),)
    );
  }
}
