import 'package:box_delivery_app/views/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 39,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(-1, -5),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                imagePath: 'assets/navbar_1.svg',
                isSelected: currentIndex == 0,
                onTap: () {},
              ),
              _buildNavItem(
                imagePath: 'assets/navbar_2.svg',
                isSelected: currentIndex == 1,
                onTap: () {},
              ),
              _buildNavItem(
                imagePath: 'assets/navbar_3.svg',
                isSelected: currentIndex == 2,
                onTap: () {},
              ),
              _buildNavItem(
                imagePath: 'assets/navbar_4.svg',
                isSelected: currentIndex == 3,
                onTap: () {
                  print("bye");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ProfileScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            imagePath,
            // color: isSelected ? const Color(0xffe25e00) : Colors.grey,
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
