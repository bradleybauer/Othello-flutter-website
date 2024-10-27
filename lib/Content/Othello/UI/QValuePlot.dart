import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../Game/Game.dart';
import '../Game/Othello.dart';

class QValuePlot extends StatelessWidget {
  const QValuePlot(
      {required this.brickEdgeLength,
      required this.height,
      required this.width,
      required this.borderColor,
      required this.game,
      required this.player,
      this.mirror = 1});
  final int mirror;
  final double brickEdgeLength;
  final double height;
  final double width;
  final Color borderColor;
  final int player;

  final Game game;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: brickEdgeLength / 13,
          ),
          borderRadius: BorderRadius.circular(brickEdgeLength / 8)),
      child: CustomPaint(
        willChange: false,
        size: Size(width, height),
        painter: QValuePlotPainter(
            brickEdgeLength: brickEdgeLength,
            qvalues: game.getQValues(player),
            mirror: mirror),
      ),
    );
  }
}

class QValuePlotPainter extends CustomPainter {
  const QValuePlotPainter(
      {required this.brickEdgeLength, required this.qvalues, this.mirror = 1});
  final int mirror;
  final double brickEdgeLength;
  final List<double?> qvalues;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey[700]!
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = brickEdgeLength / 16;
    for (int i = 0; i < qvalues.length - 1; i++) {
      if (qvalues[i] == null || qvalues[i + 1] == null) {
        // handle case where there is no action taken
        continue;
      }
      var p0 = Offset((i + .5) / Othello.MAX_NUM_TURNS,
          1 - (qvalues[i]! - 10 + .0333 * i * i) / 65);
      var p1 = Offset((i + 1.5) / Othello.MAX_NUM_TURNS,
          1 - (qvalues[i + 1]! - 10 + .0333 * (i + 1) * (i + 1)) / 65);
      p0 = Offset(
          math.min(1, math.max(0, p0.dx)), math.min(1, math.max(0, p0.dy)));
      p1 = Offset(
          math.min(1, math.max(0, p1.dx)), math.min(1, math.max(0, p1.dy)));
      p0 = Offset(mirror * (p0.dx - .5) * .9 + .5, (p0.dy - .5) * .75 + .5);
      p1 = Offset(mirror * (p1.dx - .5) * .9 + .5, (p1.dy - .5) * .75 + .5);
      p0 = p0.scale(size.width, size.height);
      p1 = p1.scale(size.width, size.height);
      canvas.drawLine(p0, p1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
