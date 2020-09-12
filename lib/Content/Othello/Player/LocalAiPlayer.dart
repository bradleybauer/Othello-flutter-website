import '../QFunction/QFunctionFake.dart' if (dart.library.js) '../QFunction/QFunctionWeb.dart';
import 'IPlayer.dart';

class LocalAiPlayer extends IPlayer {
  LocalAiPlayer(this._id);

  static const int _aiDelay = 3;

  final int _id;
  final _qFunction = QFunction();
  bool _isReady = false;

  @override
  void setup(Function callback) {
    _qFunction.setup(() {
      _isReady = true;
      callback();
    });
  }

  @override
  void getAction(List<List<int>> board, List<List<int>> validPositions, Function callback) {
    _qFunction.getAction(board, validPositions, _id, _aiDelay, callback);
  }

  @override
  int getId() => _id;

  @override
  bool isReady() => _isReady;

  @override
  void getActionCallback(List<int> action) {}
}
