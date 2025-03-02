import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/svg.dart';


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
      {'icon': 'assets/locationIcon.svg', 'route': "/add_location", 'isSvg': true},
      {'icon': 'assets/box.svg', 'route': "/add_box", 'isSvg': true},
      {'icon': 'assets/category.svg', 'route': "/items", 'isSvg': true},
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
          child: buttons[i]['isSvg']
              ? SvgPicture.asset(
            buttons[i]['icon'],
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          )
              : Icon(
            buttons[i]['icon'],
            color: Colors.white,
            size: 24,
          ),
        ),
      ));
    }

    return miniButtons;
  }
}
