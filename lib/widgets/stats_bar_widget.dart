import 'package:box_delivery_app/views/boxes_screen.dart';
import 'package:box_delivery_app/views/items_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repos/box_repository.dart';
import '../repos/item_repository.dart';
import '../repos/location_repository.dart';
import '../views/location_management_view.dart';

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
            _buildStatItem(locations.length.toString(), "Locations", const Color(0xFFFEF8E1),
                const Color(0xFFE25E00), "assets/onboarding3.png",onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LocationManagementScreen()));
                }),
            SizedBox(
              width: 3,
            ),
            _buildStatItem(boxes.length.toString(), "Boxes", const Color(0xFFF5E0FF),
                const Color(0xFFBB2BFF), "assets/onboarding3.png", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoxesView()));
            }),
            SizedBox(
              width: 3,
            ),
            _buildStatItem(items.length.toString(), "Items", const Color(0xFFE4FBE4),
                const Color(0xFF00B100), "assets/onboarding3.png"),
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
              width: 31,
              height: 27,
              decoration: BoxDecoration(
                color: imageContainerColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
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
