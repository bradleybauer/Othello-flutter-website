abstract class IQFunction {
  void setup(Function callback);
  void getAction(List<List<int>> board, List<List<int>> validPositions, int player, int delay, Function callback);
  void getQValue(List<List<int>> board, List<int> action, int player, Function callback);
}
