import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;

  const PageIndicator({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: currentPage == index ? 24 : 12,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFFE25E00)
                : const Color(0xFFD2D6DB),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
