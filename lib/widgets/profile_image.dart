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
            border: Border.all(
              color: Colors.black, // Border color
              width: 0.2, // Border thickness
            ),
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
                color: Color(0xff06a3e0),
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

// profile custom button
class ProfileCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ProfileCustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.1),
      child: SizedBox(
        width: 335,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF06a3e0)),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16), // Padding
          ),
          child: SizedBox(
            width: 303,
            height: 24,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Color(0xff06a3e0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
