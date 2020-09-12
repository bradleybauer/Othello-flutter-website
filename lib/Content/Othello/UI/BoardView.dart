import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../MyUtil.dart';
import '../Game/Game.dart';
import '../Game/Othello.dart';
import 'BoardLoadingAnimation.dart';
import 'Brick.dart';
import 'Piece.dart';
import 'PiecePlacementAnimation.dart';

class BoardBase extends StatelessWidget {
  BoardBase({this.brickDiagonalRadius});

  static const double boardFinalBoxHeightScalar = 1.3333;
  static const int baseSize = 13;
  final double brickDiagonalRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        // Make the stack that contains the board be at least as large as the board which changes how close the BoardView can be to the bottom edge
        width: baseSize * brickDiagonalRadius,
        height: 1,
      ),
      Transform(
          origin: Offset((1 / boardFinalBoxHeightScalar) * baseSize / 2 * brickDiagonalRadius,
              (1 / boardFinalBoxHeightScalar) * baseSize / 2 * brickDiagonalRadius),
          transform: Matrix4.translationValues(0, .333 * brickDiagonalRadius / math.sqrt(2), 0) *
              Matrix4.diagonal3Values(
                  boardFinalBoxHeightScalar * 1 / math.sqrt(2), boardFinalBoxHeightScalar * .5 / math.sqrt(2), 1) *
              Matrix4.rotationZ(math.pi / 4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(brickDiagonalRadius / 4),
              color: Colors.blueGrey[500],
              border: Border.all(color: Colors.blueGrey[400], width: brickDiagonalRadius),
            ),
            height: (1 / boardFinalBoxHeightScalar) * baseSize * brickDiagonalRadius,
            width: (1 / boardFinalBoxHeightScalar) * baseSize * brickDiagonalRadius,
          )),
    ]);
  }
}

class BoardView extends StatefulWidget {
  BoardView({this.game, this.brickEdgeLength, this.brickDiagonalRadius})
      : boardBase = BoardBase(brickDiagonalRadius: brickDiagonalRadius),
        whitePiece = Piece(Piece.lightColor, Piece.lightShade, brickEdgeLength),
        blackPiece = Piece(Piece.darkColor, Piece.darkShade, brickEdgeLength);

  //  Flatten the board widget array so that everything draws correctly in a stack
  static List<Widget> boardToList(board) {
    final result = <Widget>[];
    for (int i = 0; i < 8; i++) {
      for (int j = 7; j >= i; j--) {
        if (board[i][j] != null) {
          result.add(board[i][j]);
        }
      }
    }
    for (int i = 1; i < 8; i++) {
      for (int j = i; j >= 0; j--) {
        if (board[i][j] != null) {
          result.add(board[i][j]);
        }
      }
    }
    return result;
  }

  static Offset translateToGrid(int i, int j, double brickEdgeLength) {
    return Offset((i + j - 7) * brickEdgeLength / 2, .5 * (i - j) * brickEdgeLength / 2);
  }

  static Widget positionPiece(int i, int j, double brickEdgeLength, Widget chip) {
    Offset offset = translateToGrid(i, j, brickEdgeLength);
    return Transform(
      transform: Matrix4.translationValues(offset.dx, offset.dy - brickEdgeLength * Piece.brickRatio * .03, 0),
      child: chip,
    );
  }

  final Game game;

  final Widget boardBase;
  final Piece whitePiece;
  final Piece blackPiece;

  final double brickEdgeLength;
  final double brickDiagonalRadius;

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  bool isAnimating;
  bool animatePlayersGettingReady;

  @override
  void initState() {
    super.initState();

    isAnimating = true;
    animatePlayersGettingReady = true;

    widget.game.addListener(_handleGameStateChange);
  }

  @override
  void dispose() {
    widget.game.removeListener(_handleGameStateChange);
    super.dispose();
  }

  void _handleGameStateChange() {
    if (widget.game.hasGameBeenStarted()) {
      setState(() {
        isAnimating = true;
      });
    }
  }

  List<List<Widget>> _layoutBricks() {
    final availableActions = widget.game.availableActions; // cache this outside loop since it may be a get()
    final bricks = <List<Widget>>[];
    for (int i = 0; i < Othello.BOARD_SIZE; i++) {
      bricks.add([]);
      for (int j = 0; j < Othello.BOARD_SIZE; j++) {
        final bool shouldHighlight = widget.game.showHints && !isAnimating && containsList(availableActions, [i, j]);
        var onClick;
        if (widget.game.board[i][j] == Othello.EMPTY || isAnimating) {
          onClick = () {
            if (!isAnimating) {
              widget.game.getCurrentPlayer().getActionCallback([i, j]);
            }
          };
        }
        bricks[i].add(Brick(shouldHighlight, widget.brickEdgeLength, widget.brickDiagonalRadius, i, j,
            BoardView.translateToGrid(i, j, widget.brickEdgeLength), onClick));
      }
    }
    return bricks;
  }

  List<List<Widget>> _createPieces() {
    final pieces = <List<Widget>>[];
    for (int i = 0; i < Othello.BOARD_SIZE; i++) {
      pieces.add([]);
      for (int j = 0; j < Othello.BOARD_SIZE; j++) {
        if (widget.game.board[i][j] == Othello.WHITE)
          pieces[i].add(BoardView.positionPiece(i, j, widget.brickEdgeLength, widget.whitePiece));
        else if (widget.game.board[i][j] == Othello.BLACK)
          pieces[i].add(BoardView.positionPiece(i, j, widget.brickEdgeLength, widget.blackPiece));
        else
          pieces[i].add(null);
      }
    }
    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    final bricks = _layoutBricks();
    final pieces = _createPieces();

    // Animate bricks
    if (animatePlayersGettingReady) {
      return BoardLoadingAnimation(
        game: widget.game,
        brickDiagonalRadius: widget.brickDiagonalRadius,
        boardBase: widget.boardBase,
        bricks: bricks,
        animationsCompleteCallback: () {
          setState(() {
            animatePlayersGettingReady = false;
          });
        },
      );
    }

    final content = [widget.boardBase] + BoardView.boardToList(bricks);

    // Animate pieces
    List<List<int>> placements = widget.game.getPlacements();
    if (isAnimating && placements.length > 0) {
      List<List<int>> conversions = widget.game.getConversions();

      final placedPositions = <List<int>>[];
      final placedPieces = <Widget>[];
      for (var placement in placements) {
        int i = placement[0];
        int j = placement[1];
        placedPositions.add([i, j]);
        placedPieces.add(pieces[i][j]);
        pieces[i][j] = null; // do not draw the animated piece as an idle piece too
      }
      for (var conversion in conversions) {
        int i = conversion[0];
        int j = conversion[1];
        pieces[i][j] = null;
      }
      content.add(
        PiecePlacementAnimation(
          placedPositions: placedPositions,
          placedPieces: placedPieces,
          conversions: conversions,
          brickEdgeLength: widget.brickEdgeLength,
          animationCompleteCallback: () {
            setState(() {
              if (!widget.game.hasGameBeenStarted()) {
                widget.game.startGame();
              }
              isAnimating = false;
            });
          },
        ),
      );
    }

    // draw remaining idle pieces
    content.addAll(BoardView.boardToList(pieces));

    return Stack(alignment: Alignment.center, children: content);
  }
}
