abstract class IPlayer {
  void setup(Function callback);
  void getAction(List<List<int>> board, List<List<int>> validPositions, Function callback);
  void getActionCallback(List<int> action);
  int getId();
  bool isReady();
}
