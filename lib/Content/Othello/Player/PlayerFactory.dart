import 'IPlayer.dart';
import 'LocalAiPlayer.dart';
import 'LocalPlayer.dart';
import 'PlayerOptions.dart';
import 'PlayerType.dart';

class PlayerFactory {
  static IPlayer create(PlayerOptions options) {
    switch (options.playerType) {
      case PlayerType.LOCAL:
        return LocalPlayer(options.playerId);
      case PlayerType.LOCAL_AI:
        return LocalAiPlayer(options.playerId);
    }
    return null;
  }
}
