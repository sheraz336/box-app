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
      onTap: onTap, // 👈 Enables navigation on tap
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: color.withOpacity(1), // Darker background shade
                  borderRadius: BorderRadius.circular(6), // Slightly rounded square
                ),child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SvgPicture.asset(iconPath, height: 20),
                )),
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