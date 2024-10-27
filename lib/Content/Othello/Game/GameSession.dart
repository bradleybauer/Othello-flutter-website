import '../Player/IPlayer.dart';
import '../Player/PlayerFactory.dart';
import 'Game.dart';
import 'GameOptions.dart';

class GameSession {
  IPlayer? player1;
  IPlayer? player2;
  Game? game;

  void setup(GameOptions options) {
    player1 = PlayerFactory.create(options.player1Options);
    player2 = PlayerFactory.create(options.player2Options);

    // add self as listener to know when game ends
    game = Game(options, player1!, player2!);
  }
}
