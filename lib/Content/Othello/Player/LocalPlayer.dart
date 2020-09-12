import '../../MyUtil.dart';
import 'IPlayer.dart';

class LocalPlayer extends IPlayer {
  final int id;
  LocalPlayer(this.id);

  Function _callback;

  @override
  void setup(Function callback) {
//    sleep(3, callback);
  callback();
  }

  @override
  void getAction(List<List<int>> board, List<List<int>> validPositions, Function callback) {
    // local players interact with the view to get an action
    _callback = (List<int> action) {
      if (containsList(validPositions, action)) {
        callback(action);
      }
    };
  }

  @override
  int getId() => id;

  @override
  bool isReady() => true;

  @override
  void getActionCallback(List<int> action) => _callback(action);
}
