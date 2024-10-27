import 'package:board/Content/MyUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Game/Game.dart';
import 'QValuePlot.dart';

class PlayerInfoCard extends StatelessWidget {
  const PlayerInfoCard({
    Key? key,
    required this.width,
    required this.height,
    required this.borderColor,
    required this.containerBorderWidth,
    required this.containerBorderRadius,
    required this.containerPadding,
    required this.accentColor,
    required this.brickEdgeLength,
    required this.player,
    required this.game,
    this.mirror = 1,
  }) : super(key: key);

  final int mirror;
  final double width;
  final double height;
  final double brickEdgeLength;
  final double containerBorderWidth;
  final BorderRadius containerBorderRadius;
  final EdgeInsets containerPadding;
  final Color borderColor;
  final Color accentColor;
  final int player;
  final Game game;

  @override
  Widget build(BuildContext context) {
    var textDirection = mirror > 0 ? TextDirection.ltr : TextDirection.rtl;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor, width: containerBorderWidth),
          borderRadius: containerBorderRadius),
      child: Row(
        textDirection: textDirection,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: brickEdgeLength / 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                    child: Text(mirror != 1 ? ' P1' : 'P2 '),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                        fontSize: brickEdgeLength / 2, color: accentColor),
                    duration: const Duration(milliseconds: 750)),
                Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, brickEdgeLength / 10, 0),
                  child: RotatedBox(
                    quarterTurns: (mirror == 1 ? 3 : 1),
                    child: Text(RomanNumerals[game.othello.getScore(player)]!,
                        style: TextStyle(
                            fontSize: brickEdgeLength / 2.43,
                            color: Colors.grey[700])),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(brickEdgeLength / 3),
            child: QValuePlot(
                brickEdgeLength: brickEdgeLength,
                height: height * .75,
                width: width * .666,
                borderColor: accentColor,
                game: game,
                player: player,
                mirror: mirror),
          ),
        ],
      ),
    );
  }
}
