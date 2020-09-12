import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../Game/Othello.dart';
import 'BoardView.dart';
import 'Piece.dart';

class PieceConversionAnimationW extends AnimatedWidget {
  static const double t = .8;
  PieceConversionAnimationW({AnimationController controller, this.driver, this.conversion, this.brickEdgeLength})
      : super(listenable: controller) {
    final int player = conversion[2];
    final Color startColor = player == Othello.WHITE ? Colors.blueGrey[400] : Colors.amber[400];
    final Color startShade = player == Othello.WHITE ? Colors.blueGrey[600] : Colors.amber[600];
    final Color endColor = player == Othello.WHITE ? Colors.amber[400] : Colors.blueGrey[400];
    final Color endShade = player == Othello.WHITE ? Colors.amber[600] : Colors.blueGrey[600];
    color = ColorTween(begin: startColor, end: endColor).animate(CurvedAnimation(
      parent: driver,
      curve: Interval(t, 1, curve: Curves.linear),
    ));
    shade = ColorTween(begin: startShade, end: endShade).animate(CurvedAnimation(
      parent: driver,
      curve: Interval(t, 1, curve: Curves.linear),
    ));
    bounce = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: driver,
      curve: Interval(t, 1, curve: Curves.linear),
    ));
  }

  final List<int> conversion;

  Animation<double> driver;
  Animation<double> bounce;
  Animation<Color> color;
  Animation<Color> shade;

  final double brickEdgeLength;

  @override
  Widget build(BuildContext context) {
    double t = (2 * bounce.value - 1);
    double jump = 1 - t * t;
    if (bounce.value > .5) {
      jump = 1 - math.pow(t * t, 2);
    }
    final int i = conversion[0];
    final int j = conversion[1];
    return Stack(alignment: Alignment.center, children: [
      Container(
        transform: Matrix4.translationValues(0, -.25 * brickEdgeLength * jump, 0),
        child: BoardView.positionPiece(i, j, brickEdgeLength, Piece(color.value, shade.value, brickEdgeLength)),
      )
    ]);
  }
}

class PiecePlacementAnimationW extends AnimatedWidget {
  static const double t = .75;
  PiecePlacementAnimationW(
      {AnimationController controller, this.driver, this.position, this.piece, this.brickEdgeLength})
      : drop = Tween<double>(begin: -30 * brickEdgeLength, end: 0).animate(CurvedAnimation(
          parent: driver,
          curve: Interval(0.0, t, curve: Curves.linear),
        )),
        ripple = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: driver,
          curve: Interval(t, 1.0, curve: Curves.linear),
        )),
        rippleOpacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: driver,
          curve: Interval(t, 1.0, curve: Curves.linear),
        )),
        super(listenable: controller);

  final List<int> position;
  final Widget piece;

  final Animation<double> driver;
  final Animation<double> drop;
  final Animation<double> ripple;
  final Animation<double> rippleOpacity;

  final double brickEdgeLength;

  @override
  Widget build(BuildContext context) {
    final int i = position[0];
    final int j = position[1];
    return Stack(alignment: Alignment.center, children: [
      IgnorePointer(
        child: Opacity(
            opacity: rippleOpacity.value * rippleOpacity.value,
            child: Transform(
              origin: Offset(brickEdgeLength * 2, brickEdgeLength * 2),
              transform:
                  Matrix4.translationValues((i + j - 7) * brickEdgeLength / 2, .5 * (i - j) * brickEdgeLength / 2, 1) *
                      Matrix4.diagonal3Values(ripple.value, .5 * ripple.value, 1),
              child: Container(
                width: brickEdgeLength * 4,
                height: brickEdgeLength * 4,
                decoration: BoxDecoration(color: Colors.blue[200], shape: BoxShape.circle),
              ),
            )),
      ),
      Container(
        transform: Matrix4.translationValues(0, drop.value, 0),
        child: piece,
      )
    ]);
  }
}

class PiecePlacementAnimation extends StatefulWidget {
  PiecePlacementAnimation(
      {this.placedPositions,
      this.placedPieces,
      this.conversions,
      this.brickEdgeLength,
      this.animationCompleteCallback});
  final List<List<int>> placedPositions;
  final List<Widget> placedPieces;
  final List<List<int>> conversions;
  final double brickEdgeLength;
  final animationCompleteCallback;

  @override
  _PiecePlacementAnimationState createState() => _PiecePlacementAnimationState();
}

class _PiecePlacementAnimationState extends State<PiecePlacementAnimation> with TickerProviderStateMixin {
  static const int delay = 100;
  AnimationController _controller;
  List<Animation<double>> placementAnimations;
  List<Animation<double>> conversionAnimations;

  @override
  void initState() {
    super.initState();

    // TODO should the minus ones be here? get rid of the max?
    final int numPlacementMilliseconds = delay * widget.placedPieces.length;
    final int numConversionMilliseconds = delay * widget.conversions.length;
    final int numMilliseconds = 1000 + numPlacementMilliseconds + numConversionMilliseconds;

    _controller = AnimationController(duration: Duration(milliseconds: numMilliseconds), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int numPlacementMilliseconds = delay * widget.placedPieces.length;
    final int numConversionMilliseconds = delay * widget.conversions.length;
    final int numMilliseconds = 1000 + numPlacementMilliseconds + numConversionMilliseconds;
    _controller = AnimationController(duration: Duration(milliseconds: numMilliseconds), vsync: this);
    _controller.forward();
    placementAnimations = <Animation<double>>[];
    for (int i = 0; i < widget.placedPieces.length; i++) {
      placementAnimations.add(CurvedAnimation(
        parent: _controller,
        curve: Interval(i * delay / numMilliseconds, (i * delay + 1000) / numMilliseconds, curve: Curves.linear),
      ));
    }
    conversionAnimations = <Animation<double>>[];
    for (int i = 0; i < widget.conversions.length; i++) {
      final double dist = math.sqrt(math.pow(widget.conversions[i][0] - widget.placedPositions[0][0], 2) +
          math.pow(widget.conversions[i][1] - widget.placedPositions[0][1], 2));
      conversionAnimations.add(CurvedAnimation(
        parent: _controller,
        curve: Interval((numPlacementMilliseconds + dist * delay) / numMilliseconds,
            math.min(1, (numPlacementMilliseconds + dist * delay + 1000) / numMilliseconds),
            curve: Curves.linear),
      ));
    }
    if (conversionAnimations.length > 0) {
      conversionAnimations.last.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleteCallback();
        }
      });
    } else {
      placementAnimations.last.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleteCallback();
        }
      });
    }
    var animatedWidgets = <Widget>[];
    for (int i = 0; i < widget.placedPieces.length; i++) {
      animatedWidgets.add(PiecePlacementAnimationW(
          controller: _controller,
          driver: placementAnimations[i],
          position: widget.placedPositions[i],
          piece: widget.placedPieces[i],
          brickEdgeLength: widget.brickEdgeLength));
    }
    for (int i = 0; i < widget.conversions.length; i++) {
      animatedWidgets.add(PieceConversionAnimationW(
          controller: _controller,
          driver: conversionAnimations[i],
          conversion: widget.conversions[i],
          brickEdgeLength: widget.brickEdgeLength));
    }
    return Stack(
      alignment: Alignment.center,
      children: animatedWidgets,
    );
  }
}
