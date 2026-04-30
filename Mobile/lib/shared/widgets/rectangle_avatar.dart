import 'package:flutter/material.dart';

class RectangleAvatar extends StatelessWidget {
  final String name;
  final double width;
  final double height;

  const RectangleAvatar({
    super.key,
    required this.name,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
