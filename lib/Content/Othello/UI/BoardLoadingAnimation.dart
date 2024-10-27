import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../Game/Game.dart';
import 'BoardView.dart';

class BoardLoadingAnimationW extends AnimatedWidget {
  const BoardLoadingAnimationW(
      {required AnimationController controller,
      required this.brickDiagonalRadius,
      required this.bricks,
      required this.showFinishedAnimation,
      required this.boardBase})
      : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  final Widget boardBase;
  final double brickDiagonalRadius;
  final List<List<Widget>> bricks;
  final bool showFinishedAnimation;

  @override
  Widget build(BuildContext context) {
    var result = <List<Widget>>[];
    for (int i = 0; i < 8; i++) {
      result.add(<Widget>[]);
      for (int j = 0; j < 8; j++) {
        double t = _progress.value * 2 + (i + j) / 16.0;
        double y = -.75 *
                brickDiagonalRadius *
                (.5 - .5 * math.cos(t * math.pi * 2.0)) -
            brickDiagonalRadius;
        if (showFinishedAnimation) {
          t = math.min(1, _progress.value * 2 + (i + j) / 16.0);
          y = -.75 *
                  brickDiagonalRadius *
                  (.5 - .5 * math.cos(t * math.pi * 2.0)) -
              (1 - Curves.bounceOut.transform(_progress.value)) *
                  brickDiagonalRadius;
        }
        result[i].add(Transform(
            transform: Matrix4.translationValues(0, y, 0),
            child: bricks[i][j]));
      }
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[boardBase] + BoardView.boardToList(result),
    );
  }
}

class BoardLoadingAnimation extends StatefulWidget {
  const BoardLoadingAnimation(
      {required this.game,
      required this.brickDiagonalRadius,
      required this.bricks,
      required this.animationsCompleteCallback,
      required this.boardBase});

  final Game game;
  final Widget boardBase;
  final List<List<Widget>> bricks;
  final double brickDiagonalRadius;
  final animationsCompleteCallback;

  @override
  _BoardLoadingAnimationState createState() => _BoardLoadingAnimationState();
}

class _BoardLoadingAnimationState extends State<BoardLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _finishedController;
  bool readyToShowFinishedAnimation = false;

  void _finishAnimation(status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    if (widget.game.playersAreReady) {
      _loadingController.removeStatusListener(_finishAnimation);
      setState(() {
        readyToShowFinishedAnimation = true;
        _finishedController
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.animationsCompleteCallback();
            }
          });
      });
    } else {
      _loadingController
        ..reset()
        ..forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _finishedController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    _loadingController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..forward()
          ..addStatusListener(_finishAnimation);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _finishedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BoardLoadingAnimationW(
      controller: readyToShowFinishedAnimation
          ? _finishedController
          : _loadingController,
      brickDiagonalRadius: widget.brickDiagonalRadius,
      boardBase: widget.boardBase,
      bricks: widget.bricks,
      showFinishedAnimation: readyToShowFinishedAnimation,
    );
  }
}
