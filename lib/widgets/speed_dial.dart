
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
    return Container(
      // width: 300,
      height: 370,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (isOpen) ...[
            Positioned(
              bottom: 180,
              right: 0,
              child: _buildMiniButton(
                Icons.location_on,
                Color(0xffe25e00),
                    () {
                  setState(() => isOpen = false);
                  // Add location logic
                  Navigator.pushNamed(context, "/add_location");
                },
              ),
            ),
            Positioned(
              bottom: 120,
              right: 0,
              child: _buildMiniButton(
                Icons.inbox,
                Color(0xffe25e00),
                    () {
                  setState(() => isOpen = false);
                  Navigator.pushNamed(context, "/add_box");
                  // Add box logic
                },
              ),
            ),
            Positioned(
              bottom: 60,
              right: 0,
              child: _buildMiniButton(
                Icons.widgets,
                Color(0xffe25e00),
                    () {
                  setState(() => isOpen = false);
                  Navigator.pushNamed(context, "/items");
                  // Add item logic
                },
              ),
            ),
          ],
          FloatingActionButton(
            backgroundColor: Color(0xffe25e00),
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

  Widget _buildMiniButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FloatingActionButton.small(
        backgroundColor: color,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }}