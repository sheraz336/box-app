import 'package:box_delivery_app/views/profile_image.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375, // Set width
      height: 39, // Set height
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // Hex: #0000001A (10% opacity)
            offset: const Offset(-1, -5), // Matches the specified shadow direction
            blurRadius: 4, // Blur effect
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
                icon: Icons.home,
                isSelected: currentIndex == 0,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.dashboard,
                isSelected: currentIndex == 1,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.folder,
                isSelected: currentIndex == 2,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.person,
                isSelected: currentIndex == 3,
                onTap: () {
                  print("bye");
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>ProfileScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xffe25e00) : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}