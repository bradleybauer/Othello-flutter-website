import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../MyUtil.dart';
import '../Player/IPlayer.dart';
import '../QFunction/QFunctionFake.dart' if (dart.library.js) '../QFunction/QFunctionWeb.dart';
import 'GameOptions.dart';
import 'Othello.dart';

class Game extends ChangeNotifier {
  Game(GameOptions options, this.player1, this.player2) {
    assert(player1.getId() != player2.getId());

    showHints = options.showHints;

    previousBoard = othello.getEmptyBoard();

    qFunction.setup(() {
      player1.setup(() {
        player2.setup(() {
          notifyListeners();
        });
      });
    });
  }

  bool showHints;

  void startGame() {
    assert(!hasGameBeenStarted());
    if (player1.getId() == Othello.WHITE) {
      player1.getAction(board, availableActions, (action) => _takeTurn(action));
    } else {
      player2.getAction(board, availableActions, (action) => _takeTurn(action));
    }
  }

  final IPlayer player1;
  final IPlayer player2;

  final qFunction = QFunction();
  final whiteQValues = <double>[];
  final blackQValues = <double>[];

  final othello = Othello();

  bool gameFinished = false;
  bool get playersAreReady => player1.isReady() && player2.isReady();

  List<List<int>> previousBoard;
  List<List<int>> get board => othello.board;
  List<List<int>> get availableActions => othello.getLegalActions(othello.player);

  List<List<int>> getPlacements() {
    List<List<int>> placements = <List<int>>[];
    for (int i = 0; i < Othello.BOARD_SIZE; i++) {
      for (int j = 0; j < Othello.BOARD_SIZE; j++) {
        if (board[i][j] != previousBoard[i][j]) {
          if (previousBoard[i][j] == Othello.EMPTY) {
            placements.add([i, j, board[i][j]]);
          }
        }
      }
    }
    return placements;
  }

  List<List<int>> getConversions() {
    List<List<int>> conversions = <List<int>>[];
    for (int i = 0; i < Othello.BOARD_SIZE; i++) {
      for (int j = 0; j < Othello.BOARD_SIZE; j++) {
        if (board[i][j] != previousBoard[i][j]) {
          if (previousBoard[i][j] != Othello.EMPTY) {
            conversions.add([i, j, board[i][j]]);
          }
        }
      }
    }
    return conversions;
  }

  void _trackQValues(List<int> action, Function callback) {
    var qvalues = getQValues(othello.player);
    if (listEquals(action, Othello.NOOP_ACTION)) {
      qvalues.add(null);
    } else {
      qFunction.getQValue(board, action, othello.player, (value) {
        qvalues.add(value);
        callback([...action]);
      });
    }
  }

  void _takeTurn(List<int> action) {
    assert(action != null);

    if (gameFinished || !playersAreReady || !containsList(availableActions, action)) {
      return;
    }

    final _finishTurn = (List<int> action) {
      previousBoard = othello.copyBoard();

      // apply action
      gameFinished = othello.step(action);

      // tell next player to get an action
      if (availableActions.length > 0) {
        if (player1.getId() == othello.player) {
          player1.getAction(board, availableActions, (action) => _takeTurn(action));
        } else {
          player2.getAction(board, availableActions, (action) => _takeTurn(action));
        }
      } else {
        // No action available so schedule a repaint to move the game forward
        sleep(1, () => _takeTurn(Othello.NOOP_ACTION));
      }

      notifyListeners();
    };

    // Using the qfunction is async so we have to do the rest of the turn in a callback
    _trackQValues(action, _finishTurn);
  }

  bool hasGameBeenStarted() =>
      othello.blackPlayerNumPieces != Othello.NUM_STARTING_PIECES - 2 ||
      othello.whitePlayerNumPieces != Othello.NUM_STARTING_PIECES - 2;

  List<double> getQValues(int player) {
    if (player == Othello.WHITE) {
      return whiteQValues;
    } else {
      return blackQValues;
    }
  }

  IPlayer getCurrentPlayer() {
    if (player1.getId() == othello.player) {
      return player1;
    }
    return player2;
  }
}
