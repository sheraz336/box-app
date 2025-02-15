import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryTab extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : color.withOpacity(0.1), // Lighter background
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.5), // Stronger border when selected
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, height: 20),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
