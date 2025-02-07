import 'package:box_delivery_app/views/profile_image.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({Key? key, required int currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home), onPressed: () {}),
          IconButton(icon: const Icon(Icons.grid_view), onPressed: () {}),
          const SizedBox(width: 32), // Space for FAB
          IconButton(icon: const Icon(Icons.folder), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {
            print("hello");
            Navigator.push(context, MaterialPageRoute(builder: (c)=>ProfileScreen()));
          }),
        ],
      ),
    );
  }
}
