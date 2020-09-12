import 'dart:math' as math;

import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  const Brick(this.highlight, this.brickEdgeLength, this.brickDiagonalRadius, this.i, this.j, this.offset, this.onTap);

  final int i;
  final int j;
  final Offset offset;
  final onTap;
  final bool highlight;
  final double brickEdgeLength;
  final double brickDiagonalRadius;

  @override
  Widget build(BuildContext context) {
    final Color color = highlight ? Colors.blueGrey[200] : Colors.grey[200];
    final Color shade = Colors.grey[300];
    final Color borderColor = Colors.blueGrey;
    final Color hoverColor = Colors.pinkAccent;

    final double zHeight = .333 * brickDiagonalRadius;
    const double verticalScale = .5;
    final double borderSize1 = brickEdgeLength / 15;
    final double borderSize2 = brickEdgeLength / 40;
    final border = Border(
      top: BorderSide(color: (i == 0) ? Colors.pink : borderColor, width: (i == 0) ? borderSize1 : borderSize2),
      bottom: BorderSide(color: (i == 7) ? Colors.pink : borderColor, width: (i == 7) ? borderSize1 : borderSize2),
      left: BorderSide(color: (j == 7) ? Colors.pink : borderColor, width: (j == 7) ? borderSize1 : borderSize2),
      right: BorderSide(color: (j == 0) ? Colors.pink : borderColor, width: (j == 0) ? borderSize1 : borderSize2),
    );

    final double adjust = brickEdgeLength / 16;

    return Transform(
      origin: Offset((brickEdgeLength + zHeight) / 2, (brickEdgeLength + zHeight) / 2),
      transform: Matrix4.translationValues(offset.dx, offset.dy + adjust, 0) *
          Matrix4.diagonal3Values(-1 / math.sqrt(2), verticalScale / math.sqrt(2), 1) *
          Matrix4.rotationZ(math.pi / 4),
      child: Container(
        height: brickEdgeLength + zHeight,
        width: brickEdgeLength + zHeight,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: brickEdgeLength,
                  height: brickEdgeLength,
                  decoration: BoxDecoration(border: border),
                  child: Material(
                    color: color,
                    child: InkWell(onTap: onTap, canRequestFocus: false, hoverColor: hoverColor),
                  ),
                ),
                Container(
                  transform: Matrix4.skewY(math.pi / 4),
                  width: zHeight,
                  height: brickEdgeLength,
                  color: color,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  transform: Matrix4.skewX(math.pi / 4),
                  width: brickEdgeLength,
                  height: zHeight,
                  color: shade,
                ),
//              Container(width: zHeight, height: zHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
