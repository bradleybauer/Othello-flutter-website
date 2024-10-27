import 'package:flutter/foundation.dart';

class Othello {
  static const BOARD_SIZE = 8;
  static const WHITE = 1;
  static const BLACK = -1;
  static const EMPTY = 0;
  static const NUM_STARTING_PIECES = 32;
  static const MAX_NUM_TURNS = 30;
  static const NOOP_ACTION = [-1, -1];

  int player = 0;
  List<List<int>> board = <List<int>>[];
  bool previousPlayerSkipped = false;
  int blackPlayerNumPieces = 0;
  int whitePlayerNumPieces = 0;

  Othello() {
    reset();
  }

  reset() {
    this.board = getInitialBoard();
    this.player = WHITE;
    this.previousPlayerSkipped = false;
    this.blackPlayerNumPieces = NUM_STARTING_PIECES - 2;
    this.whitePlayerNumPieces = NUM_STARTING_PIECES - 2;
    return copyBoard();
  }

  List<List<int>> copyBoard() {
    var boardCopy = List<List<int>>.from(board);
    for (int i = 0; i < BOARD_SIZE; i++) {
      boardCopy[i] = List<int>.from(boardCopy[i]);
    }
    return boardCopy;
  }

  List<List<int>> getEmptyBoard() {
    var board = <List<int>>[];
    for (int i = 0; i < BOARD_SIZE; i++) {
      board.add(<int>[]);
      for (int k = 0; k < BOARD_SIZE; k++) {
        board[i].add(0);
      }
    }
    return board;
  }

  List<List<int>> getInitialBoard() {
    board = getEmptyBoard();
    board[BOARD_SIZE ~/ 2 - 1][BOARD_SIZE ~/ 2 - 1] = WHITE;
    board[BOARD_SIZE ~/ 2][BOARD_SIZE ~/ 2] = WHITE;
    board[BOARD_SIZE ~/ 2 - 1][BOARD_SIZE ~/ 2] = BLACK;
    board[BOARD_SIZE ~/ 2][BOARD_SIZE ~/ 2 - 1] = BLACK;
    return board;
  }

  int getScore(whichPlayer) {
    int score = 0;
    for (int i = 0; i < BOARD_SIZE; i++)
      for (int j = 0; j < BOARD_SIZE; j++)
        if (board[i][j] == whichPlayer) score += 1;
    return score;
  }

  List<List<int>> getLegalActions(whichPlayer) {
    // Find open positions on the perimeter
    var openPositions = [];
    for (int i = 0; i < BOARD_SIZE; i++) {
      for (int j = 0; j < BOARD_SIZE; j++) {
        if (board[i][j] == Othello.EMPTY) {
          bool isAvailable = false;
          // check surrounding tiles for at least 1 enemy
          for (int di = -1; di <= 1; di++) {
            for (int dj = -1; dj <= 1; dj++) {
              if (di == 0 && dj == 0) continue;
              if (coordinateInBounds(i + di, j + dj)) {
                isAvailable = board[i + di][j + dj] == -whichPlayer;
              }
              if (isAvailable) break;
            }
            if (isAvailable) break;
          }
          if (isAvailable) openPositions.add([i, j]);
        }
      }
    }

    // Which of those positions are legal plays?
    int enemy = -whichPlayer;
    List<List<int>> actions = [];
    for (var pos in openPositions) {
      int i = pos[0];
      int j = pos[1];
      bool isValidPlay = false;
      for (int di = -1; di <= 1; di++) {
        for (int dj = -1; dj <= 1; dj++) {
          if (di == 0 && dj == 0) continue;
          for (int k = 1; k < BOARD_SIZE; k++) {
            int ip = i + k * di;
            int jp = j + k * dj;
            if (!coordinateInBounds(ip, jp)) {
              break;
            }
            if (k >= 2 && board[ip][jp] == whichPlayer) {
              isValidPlay = true;
              break;
            }
            if (board[ip][jp] != enemy) {
              break;
            }
          }
          if (isValidPlay) break;
        }
        if (isValidPlay) break;
      }
      if (isValidPlay) actions.add([i, j]);
    }

    return actions;
  }

  bool step(action) {
    bool done = false;
    if (!listEquals(action, NOOP_ACTION)) {
      if (player == Othello.BLACK)
        blackPlayerNumPieces -= 1;
      else
        whitePlayerNumPieces -= 1;

      int i = action[0];
      int j = action[1];
      board[i][j] = player;

      // Flip enemy discs
      for (int di = -1; di <= 1; di++) {
        for (int dj = -1; dj <= 1; dj++) {
          if (di == 0 && dj == 0) continue;
          for (int k = 1; k < BOARD_SIZE; k++) {
            int ip = i + k * di;
            int jp = j + k * dj;
            if (!coordinateInBounds(ip, jp)) {
              break;
            }
            if (board[ip][jp] == Othello.EMPTY) {
              break;
            }
            if (board[ip][jp] == player) {
              for (int kp = 1; kp < k; kp++) {
                int ip = i + kp * di;
                int jp = j + kp * dj;
                board[ip][jp] = player;
              }
              break;
            }
          }
        }
      }

      previousPlayerSkipped = false;
    } else {
      // Game ends if neither player can play a piece
      if (previousPlayerSkipped) {
        done = true;
      }
      previousPlayerSkipped = true;
    }
    player = -player;
    return done;
  }

  bool coordinateInBounds(i, j) {
    return i >= 0 && i < BOARD_SIZE && j >= 0 && j < BOARD_SIZE;
  }
}
