import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Game/Game.dart';
import '../Game/Othello.dart';
import 'Piece.dart';
import 'PlayerInfoCard.dart';

class HudView extends StatelessWidget {
  HudView({this.game, this.brickEdgeLength, this.brickDiagonalRadius, this.quitPlayingButtonCallback});

  static const int baseSize = 13;

  final Null Function() quitPlayingButtonCallback;

  final Game game;
  final double brickEdgeLength;
  final double brickDiagonalRadius;

  _transformCard({Widget child, double height, double width, int direction}) {
    return Transform(
        origin: Offset(width / 2, height / 2),
        transform: Matrix4.translationValues(direction * HudView.baseSize / 4 * brickEdgeLength,
                .333 * brickDiagonalRadius / math.sqrt(2) - HudView.baseSize / 7.5 * brickEdgeLength, 0) *
            Matrix4.diagonal3Values(1 / math.sqrt(2), .5 / math.sqrt(2), 1) *
            Matrix4.rotationZ(direction * math.pi / 4),
        child: child);
  }

  _transformButton({Widget child, double height, double width, int direction}) {
    return Transform(
        origin: Offset(width / 2, height / 2),
        transform: Matrix4.translationValues(direction * HudView.baseSize / 3.7 * brickEdgeLength,
                -.333 * brickDiagonalRadius / math.sqrt(2) + brickEdgeLength * .75, 0) *
            Matrix4.diagonal3Values(1 / math.sqrt(2), .5 / math.sqrt(2), 1) *
            Matrix4.rotationZ(-direction * math.pi / 4),
        child: child);
  }

  _transformButton2({Widget child, double height, double width, int direction}) {
    return Transform(
        origin: Offset(width / 2, height / 2),
        transform: Matrix4.translationValues(direction * HudView.baseSize / 4.2 * brickEdgeLength,
                -.333 * brickDiagonalRadius / math.sqrt(2) + brickEdgeLength * .433, 0) *
            Matrix4.diagonal3Values(1 / math.sqrt(2), .5 / math.sqrt(2), 1) *
            Matrix4.rotationZ(-direction * math.pi / 4),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final width = brickEdgeLength * 8;
    final height = brickEdgeLength * 3;
    final containerBorderWidth = brickEdgeLength / 10;
    final containerBorderRadius = BorderRadius.all(Radius.circular(brickDiagonalRadius / 4));
    final containerPadding = EdgeInsets.symmetric(vertical: 0, horizontal: brickEdgeLength / 2);

    final lightBorderColor = game.othello.player == Othello.WHITE ? Piece.lightShade : Colors.grey[200];
    final darkBorderColor = game.othello.player != Othello.WHITE ? Piece.darkColor : Colors.grey[200];
    final lightAccentColor = game.othello.player == Othello.WHITE ? Colors.lightBlueAccent : Colors.grey[200];
    final darkAccentColor = game.othello.player != Othello.WHITE ? Colors.greenAccent : Colors.grey[200];

    // A hack to make sure that accidentally hitting tab does not focus the buttons
    FocusScope.of(context).requestFocus(FocusNode());

    return Stack(alignment: Alignment.center, children: [
      Container(height: brickEdgeLength * 10, width: brickEdgeLength * 10),
      _transformCard(
          child: PlayerInfoCard(
              width: width,
              height: height,
              borderColor: lightBorderColor,
              containerBorderWidth: containerBorderWidth,
              containerBorderRadius: containerBorderRadius,
              containerPadding: containerPadding,
              accentColor: lightAccentColor,
              brickEdgeLength: brickEdgeLength,
              player: Othello.WHITE,
              game: game,
              mirror: -1),
          height: height,
          width: width,
          direction: -1),
      _transformCard(
          child: PlayerInfoCard(
              width: width,
              height: height,
              borderColor: darkBorderColor,
              containerBorderWidth: containerBorderWidth,
              containerBorderRadius: containerBorderRadius,
              containerPadding: containerPadding,
              accentColor: darkAccentColor,
              brickEdgeLength: brickEdgeLength,
              player: Othello.BLACK,
              game: game),
          height: height,
          width: width,
          direction: 1),
      _transformButton(
          child: MyButton(
            brickEdgeLength: brickEdgeLength,
            playButtonTap: quitPlayingButtonCallback,
          ),
          height: brickEdgeLength * 4,
          width: brickEdgeLength * 2,
          direction: 1),
      _transformButton2(
          child: AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(seconds: 1),
              transform: Matrix4.translationValues(
                  brickEdgeLength / 6, game.playersAreReady ? -brickEdgeLength * 2 : -brickEdgeLength * .1, 0),
              child: MessageBox(message: 'L O A D I N G', brickEdgeLength: brickEdgeLength)),
          height: brickEdgeLength * 4,
          width: brickEdgeLength * 2,
          direction: -1),
    ]);
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({this.message, this.brickEdgeLength});

  final double brickEdgeLength;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: brickEdgeLength / 5, horizontal: brickEdgeLength / 2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(brickEdgeLength / 4),
          border: Border.all(
            color: Colors.blueGrey[400],
            width: brickEdgeLength / 12,
          )),
      child: Text(message,
          style: TextStyle(
            fontSize: brickEdgeLength / 2,
            color: Colors.blueGrey[400],
          )),
    );
  }
}

class MyButton extends StatefulWidget {
  const MyButton({
    @required this.brickEdgeLength,
    @required this.playButtonTap,
  });

  final double brickEdgeLength;
  final Null Function() playButtonTap;

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool acceptedButtonHover = false;

  @override
  Widget build(BuildContext context) {
    var playButtonHover = (hover) {
      setState(() {
        acceptedButtonHover = hover;
      });
    };
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.brickEdgeLength / 5),
        side: BorderSide(
          color: Colors.blueGrey[400],
          width: widget.brickEdgeLength / 12,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      color: acceptedButtonHover ? Colors.blueGrey[400] : Colors.white,
      child: InkWell(
        hoverColor: Colors.blueGrey[400],
        onHover: playButtonHover,
        onTap: widget.playButtonTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.brickEdgeLength / 4.5, horizontal: widget.brickEdgeLength / 2),
          child: Text(
            'Q U I T',
            style: TextStyle(
              fontSize: widget.brickEdgeLength / 2,
              color: acceptedButtonHover ? Colors.white : Colors.blueGrey[400],
            ),
          ),
        ),
      ),
    );
  }
}
