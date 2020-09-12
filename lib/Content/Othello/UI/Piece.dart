import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  static const Color lightColor = Color(0xFFFFCA28);
  static const Color lightShade = Color(0xFFFFB300);
  static const Color darkColor = Color(0xFF78909C);
  static const Color darkShade = Color(0xFF546E7A);

  const Piece(this.color, this.shade, this.brickEdgeLength);

  static const brickRatio = .4;

  final double brickEdgeLength;
  final Color color;
  final Color shade;

  @override
  Widget build(BuildContext context) {
    final double width = brickEdgeLength * brickRatio;
    final double height = width / 4 + width / 6;
    final double vertOff = height / 4;

    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            transform: Matrix4.translationValues(0, width / 12 - vertOff, 0),
            height: width / 6,
            width: width,
            color: shade,
          ),
          Transform(
              origin: Offset(width / 2, width / 2),
              transform: Matrix4.translationValues(0, width / 6 - vertOff, 0) * Matrix4.diagonal3Values(1, .5, 1),
              child: Container(
                  height: width, width: width, decoration: BoxDecoration(color: shade, shape: BoxShape.circle))),
          Transform(
              origin: Offset(width / 2, width / 2),
              transform: Matrix4.translationValues(0, -vertOff, 0) * Matrix4.diagonal3Values(1, .5, 1),
              child: Container(
                  height: width, width: width, decoration: BoxDecoration(shape: BoxShape.circle, color: color))),
        ],
      ),
    );
  }
}
