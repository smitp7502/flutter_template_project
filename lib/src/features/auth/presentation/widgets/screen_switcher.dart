import 'package:flutter/material.dart';

class ScreenSwitcher extends StatelessWidget {
  final String title;
  final String screen;
  final Function() onTap;
  const ScreenSwitcher({
    super.key,
    required this.screen,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: screen,
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
