import 'package:flutter/material.dart';
import 'dart:math';

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
      height: 250,
      width: 250,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (isOpen) ..._buildMiniButtons(),
          FloatingActionButton(
            backgroundColor: const Color(0xff06a3e0),
            shape: const CircleBorder(),
            onPressed: () {
              setState(() => isOpen = !isOpen);
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

  List<Widget> _buildMiniButtons() {
    List<Map<String, dynamic>> buttons = [
      {'icon': Icons.location_on, 'route': "/add_location"},
      {'icon': Icons.inbox, 'route': "/add_box"},
      {'icon': Icons.widgets, 'route': "/items"},
    ];

    double radius = 75; // Adjust to control the half-circle radius
    List<Widget> miniButtons = [];

    for (int i = 0; i < buttons.length; i++) {
      double angle = pi * (i + 0.03) / (buttons.length + 1); // Evenly distribute angles

      double dx = cos(angle) * radius; // X-axis position
      double dy = sin(angle) * radius; // Y-axis position

      miniButtons.add(Positioned(
        bottom: dy,
        right: dx,
        child: FloatingActionButton.small(
          backgroundColor: const Color(0xff06a3e0),
          shape: const CircleBorder(),
          onPressed: () {
            setState(() => isOpen = false);
            Navigator.pushNamed(context, buttons[i]['route']);
          },
          child: Icon(
            buttons[i]['icon'],
            color: Colors.white,
            size: 20,
          ),
        ),
      ));
    }

    return miniButtons;
  }
}
