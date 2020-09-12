import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import '../Game/GameOptions.dart';
import '../Game/Othello.dart';
import '../Player/PlayerType.dart';

class Curtain extends StatelessWidget {
  Curtain({this.open, this.screenWidth, this.screenHeight, this.child, this.callback});

  final bool open;
  final double screenWidth;
  final double screenHeight;
  final Widget child;
  final Null Function() callback;

  @override
  Widget build(BuildContext context) {
    final double width = math.min(screenWidth, screenHeight) * .1;
    var numTriangles = math.min((screenHeight / width).ceil(), 100);
    var edge = <Widget>[];
    var box = Transform.rotate(
        angle: math.pi / 4,
        origin: Offset(width, 0),
        child: Container(
          width: width,
          height: width,
          color: Colors.black,
        ));
    for (int i = 0; i < numTriangles; i++) {
      edge.add(box);
    }
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1250),
      curve: Curves.easeInOut,
      left: open ? screenWidth : -width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: screenHeight,
            child: Transform(
              transform: Matrix4.diagonal3Values(1.01, 1.21, 0),
              child: OverflowBox(
                maxHeight: screenHeight * 1.1,
                maxWidth: screenWidth,
                child:
                    Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.end, children: edge),
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.black,
            child: child,
          ),
        ],
      ),
      onEnd: callback,
    );
  }
}

class MenuPage extends StatefulWidget {
  MenuPage(
      {this.screenWidth,
      this.screenHeight,
      this.brickEdgeLength,
      this.dismissCallback,
      this.animationDoneCallback,
      this.showMenu});

  final bool showMenu;
  final double screenWidth;
  final double screenHeight;
  final double brickEdgeLength;
  final Null Function(GameOptions) dismissCallback;
  final Null Function() animationDoneCallback;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  GameOptions options;

  bool showHintsHover = false;

  @override
  void initState() {
    super.initState();
    options = GameOptions();
    options.player1Options.playerType = PlayerType.LOCAL;
    options.player2Options.playerType = PlayerType.LOCAL_AI;
    options.showHints = true;

    // assume that player 1 is always white
    options.player1Options.playerId = Othello.WHITE;
    options.player2Options.playerId = Othello.BLACK;
  }

  @override
  Widget build(BuildContext context) {
    return Curtain(
        open: !widget.showMenu,
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
        callback: widget.animationDoneCallback,
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: widget.brickEdgeLength / 2, fontFamily: 'Nintendo'),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 3),
                Text(
                  'R E V E R S I',
                  style: TextStyle(fontSize: widget.brickEdgeLength * .75, fontFamily: 'Nintendo', color: Colors.white),
                ),
                Transform(
                  origin: Offset(widget.brickEdgeLength * .75 * 7 / 1.426, widget.brickEdgeLength / 2),
                  transform: Matrix4.rotationZ(math.pi),
                  child: Text(
                    'R E V E R S I',
                    style: TextStyle(
                        fontSize: widget.brickEdgeLength * .75, fontFamily: 'Nintendo', color: Colors.grey[800]),
                  ),
                ),
                Spacer(flex: 3),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('PLAYER 1'),
                  SizedBox(width: widget.brickEdgeLength),
                  SwitchText(
                      firstText: 'HUMAN',
                      secondText: 'AI',
                      initialValue: options.player1Options.playerType == PlayerType.LOCAL,
                      brickEdgeLength: widget.brickEdgeLength,
                      onSwitch: (bool firstSelected) {
                        setState(() {
                          options.player1Options.playerType = firstSelected ? PlayerType.LOCAL : PlayerType.LOCAL_AI;
                        });
                      }),
                ]),
                Spacer(),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('PLAYER 2'),
                  SizedBox(width: widget.brickEdgeLength),
                  SwitchText(
                      firstText: 'HUMAN',
                      secondText: 'AI',
                      initialValue: options.player2Options.playerType == PlayerType.LOCAL,
                      brickEdgeLength: widget.brickEdgeLength,
                      onSwitch: (bool firstSelected) {
                        setState(() {
                          options.player2Options.playerType = firstSelected ? PlayerType.LOCAL : PlayerType.LOCAL_AI;
                        });
                      }),
                ]),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('SHOW HINTS'),
                    SizedBox(width: widget.brickEdgeLength),
                    SwitchText(
                      firstText: 'YES',
                      secondText: 'NO',
                      initialValue: options.showHints,
                      brickEdgeLength: widget.brickEdgeLength,
                      onSwitch: (bool firstSelected) {
                        options.showHints = firstSelected;
                      },
                    ),
                  ],
                ),
                Spacer(),
                Spacer(flex: 4),
                NintendoButton(
                  brickEdgeLength: widget.brickEdgeLength,
                  playButtonTap: () => widget.dismissCallback(options),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        ));
  }
}

class SwitchText extends StatefulWidget {
  SwitchText({this.firstText, this.secondText, this.onSwitch, this.brickEdgeLength, this.initialValue});

  final bool initialValue;
  final String firstText;
  final String secondText;
  final double brickEdgeLength;
  final Null Function(bool) onSwitch;

  @override
  _SwitchTextState createState() => _SwitchTextState();
}

class _SwitchTextState extends State<SwitchText> {
  bool firstSelected;
  bool hoverFirst;
  bool hoverSecond;

  @override
  void initState() {
    firstSelected = widget.initialValue;
    hoverFirst = false;
    hoverSecond = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: widget.brickEdgeLength / 8, horizontal: widget.brickEdgeLength / 4),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                firstSelected = true;
                widget.onSwitch(firstSelected);
              });
            },
            onHover: (hover) {
              setState(() {
                hoverFirst = hover;
              });
            },
            child: Text(widget.firstText,
                style: TextStyle(
                    color: hoverFirst
                        ? Color.fromARGB(255, 181, 235, 242)
                        : firstSelected ? Colors.red : Colors.grey[800])),
          ),
          SizedBox(width: widget.brickEdgeLength / 2),
          InkWell(
            onTap: () {
              setState(() {
                firstSelected = false;
                widget.onSwitch(firstSelected);
              });
            },
            onHover: (hover) {
              setState(() {
                hoverSecond = hover;
              });
            },
            child: Text(widget.secondText,
                style: TextStyle(
                    color: hoverSecond
                        ? Color.fromARGB(255, 181, 235, 242)
                        : !firstSelected ? Colors.red : Colors.grey[800])),
          ),
        ],
      ),
    );
  }
}

class NintendoButton extends StatefulWidget {
  const NintendoButton({
    @required this.brickEdgeLength,
    @required this.playButtonTap,
  });

  final double brickEdgeLength;
  final Null Function() playButtonTap;

  @override
  _NintendoButtonState createState() => _NintendoButtonState();
}

class _NintendoButtonState extends State<NintendoButton> {
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
          color: acceptedButtonHover ? Color.fromARGB(255, 181, 235, 242) : Colors.white,
          width: widget.brickEdgeLength / 12,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      color: Colors.black,
      child: InkWell(
        hoverColor: Color.fromARGB(255, 181, 235, 242),
        onHover: playButtonHover,
        onTap: widget.playButtonTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.brickEdgeLength / 4.5, horizontal: widget.brickEdgeLength / 2),
          child: Text(
            'PLAY',
            style: TextStyle(
                fontSize: widget.brickEdgeLength / 2,
                fontFamily: 'Nintendo',
                color: acceptedButtonHover ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
