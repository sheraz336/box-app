import 'package:flutter/material.dart';

class SpeedDialFAB extends StatefulWidget {
  const SpeedDialFAB({Key? key}) : super(key: key);

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (isOpen) ...[
            _buildMiniButton(
              icon: Icons.location_on,
              color: const Color(0xff06a3e0),
              position: 180,
              onPressed: () {
                setState(() => isOpen = false);
                Navigator.pushNamed(context, "/add_location");
              },
            ),
            _buildMiniButton(
              icon: Icons.inbox,
              color: const Color(0xff06a3e0),
              position: 120,
              onPressed: () {
                setState(() => isOpen = false);
                Navigator.pushNamed(context, "/add_box");
              },
            ),
            _buildMiniButton(
              icon: Icons.widgets,
              color: const Color(0xff06a3e0),
              position: 60,
              onPressed: () {
                setState(() => isOpen = false);
                Navigator.pushNamed(context, "/items");
              },
            ),
          ],
          FloatingActionButton(
            backgroundColor: const Color(0xff06a3e0),
            shape: const CircleBorder(), // Ensures circular shape
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Icon(
              isOpen ? Icons.close : Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniButton({
    required IconData icon,
    required Color color,
    required double position,
    required VoidCallback onPressed,
  }) {
    return Positioned(
      bottom: position,
      right: 0,
      child: FloatingActionButton.small(
        backgroundColor: color,
        shape: const CircleBorder(), // Ensures circular shape
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
