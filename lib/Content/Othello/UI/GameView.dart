import 'dart:math' as math;

import 'package:board/Content/Othello/UI/AnimatedBackground.dart';
import 'package:board/Content/Othello/UI/BoardView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Game/Game.dart';
import '../Game/GameOptions.dart';
import '../Game/GameSession.dart';
import 'HudView.dart';
import 'MenuPage.dart';

class GameView extends StatefulWidget {
  GameView({required this.screenWidth, required this.screenHeight});

  final double screenWidth;
  final double screenHeight;

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool inMenu = true;
  bool inGame = false;
  bool inGame2MenuTransition = false;
  GameSession session = GameSession();

  @override
  Widget build(BuildContext context) {
    final screenWidth = widget.screenWidth;
    final screenHeight = widget.screenHeight;
    final brickEdgeLength = 1 / 10 * math.min(screenWidth, screenHeight);
    final brickDiagonalRadius = .5 * math.sqrt(2) * brickEdgeLength;

    if (inMenu) {
      return Stack(alignment: Alignment.center, children: [
        MenuPage(
            showMenu: inMenu,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            brickEdgeLength: brickEdgeLength,
            dismissCallback: (GameOptions options) {
              setState(() {
                session.setup(options);
                inMenu = false;
                inGame = true;
              });
            })
      ]);
    }

    if (inGame) {
      return Stack(alignment: Alignment.center, children: [
        AnimatedBackground(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          brickEdgeLength: brickEdgeLength,
        ),
        ChangeNotifierProvider.value(
            value: session.game,
            child: Consumer<Game>(
                builder: (_, _game, __) => HudView(
                    game: _game,
                    brickEdgeLength: brickEdgeLength,
                    brickDiagonalRadius: brickDiagonalRadius,
                    quitPlayingButtonCallback: () {
                      setState(() {
                        inGame2MenuTransition = true;
                      });
                    }))),
        BoardView(
            game: session.game!,
            brickEdgeLength: brickEdgeLength,
            brickDiagonalRadius: brickDiagonalRadius),
        MenuPage(
            showMenu: inGame2MenuTransition,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            brickEdgeLength: brickEdgeLength,
            dismissCallback: (GameOptions options) {},
            animationDoneCallback: () {
              if (inGame2MenuTransition) {
                setState(() {
                  inGame2MenuTransition = false;
                  inMenu = true;
                  inGame = false;
                });
              }
            })
      ]);
    }
    return Stack();
  }
}
