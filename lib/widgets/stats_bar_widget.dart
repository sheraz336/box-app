
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../repos/box_repository.dart';
import '../repos/item_repository.dart';
import '../repos/location_repository.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationRepository>().list;
    final boxes = context.watch<BoxRepository>().list;
    final items = context.watch<ItemRepository>().list;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(locations.length.toString(), "Locations", const Color(
                0xFFE1EFFE),
                const Color(0xFF06a3e0), "assets/locationIcon.svg",onTap: (){
                  Navigator.pushNamed(context,"/manage_location");
                }),
            SizedBox(
              width: 3,
            ),
            _buildStatItem(boxes.length.toString(), "Boxes", const Color(0xFFF5E0FF),
                const Color(0xFFBB2BFF), "assets/box.svg", onTap: () {
              Navigator.pushNamed(context,"/manage_boxes");
            }),
            SizedBox(
              width: 3,
            ),
            _buildStatItem(items.length.toString(), "Items", const Color(0xFFE4FBE4),
                const Color(0xFF00B100), "assets/category.svg",onTap: (){
                  Navigator.pushNamed(context,"/manage_items");
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color containerColor,
      Color imageContainerColor, String imagePath,
      {Function()? onTap}) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 111,
        height: 110,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 11),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: imageContainerColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4D4D4D),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4D4D4D),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
