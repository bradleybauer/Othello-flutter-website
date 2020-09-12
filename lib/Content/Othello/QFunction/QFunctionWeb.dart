@JS()
library onnx;

import 'package:js/js.dart';

import 'IQFunction.dart';

external setupJS(String url, Function callback);
external getActionJS(List<List<int>> board, List<List<int>> validPositions, Function callback, int delay);
external getQValueJS(List<List<int>> board, List<int> action, Function callback);

class QFunction extends IQFunction {
  static const String url = 'QFunction.onnx';

  setup(Function callback) {
    setupJS(url, allowInterop(callback));
  }

  getAction(List<List<int>> board, List<List<int>> validPositions, int player, int delay, Function callback) {
    var _board = board.map((i) => i.map((j) => j * player).toList()).toList();
    return getActionJS(_board, validPositions, allowInterop((_action) {
      List<int> action = [_action[0], _action[1]];
      callback(action);
    }), delay);
  }

  getQValue(List<List<int>> board, List<int> action, int player, Function callback) {
    var _board = board.map((i) => i.map((j) => j * player).toList()).toList();
    getQValueJS(_board, action, allowInterop(callback));
  }
}
