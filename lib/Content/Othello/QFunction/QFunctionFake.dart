import '../../MyUtil.dart';
import 'IQFunction.dart';

class QFunction extends IQFunction {
  static bool hasSetup = false;

  setup(Function callback) {
    if (hasSetup) {
      callback();
      return;
    }
    hasSetup = true;
    sleep(2, callback);
  }

  @override
  void getAction(List<List<int>> board, List<List<int>> validPositions, int player, int delay, Function callback) {
    sleep(delay, () {
      callback([validPositions[0][0], validPositions[0][1]]);
    });
  }

  @override
  void getQValue(List<List<int>> board, List<int> action, int player, Function callback) {
    callback(0.0);
  }
}
