import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImageWidget extends StatelessWidget {
  final Widget? image; // Custom image widget
  final Widget icon; // Custom icon widget
  final VoidCallback onMoreTap; // Callback for the edit button

  const ProfileImageWidget({
    Key? key,
    this.image,
    required this.icon,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main circular container for the profile image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: image ?? Icon(Icons.person, size: 50, color: Colors.grey),
        ),
        // Edit button positioned at the bottom-right
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onMoreTap,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xffe25e00),
                shape: BoxShape.circle,
              ),
              child: icon, // Use the custom icon
            ),
          ),
        ),
      ],
    );
  }
}