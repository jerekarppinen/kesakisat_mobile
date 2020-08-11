import 'package:kesakisat_mobile/events/player_event.dart';
import 'package:kesakisat_mobile/models/player.dart';

class UpdatePlayer extends PlayerEvent {
  Player newPlayer;
  int playerIndex;

  UpdatePlayer(int index, Player player) {
    newPlayer = player;
    playerIndex = index;
  }
}