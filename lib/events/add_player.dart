import 'package:kesakisat_mobile/events/player_event.dart';
import 'package:kesakisat_mobile/models/player.dart';

class AddPlayer extends PlayerEvent {
  Player newPlayer;

  AddPlayer(Player player) {
    newPlayer = player;
  }
}