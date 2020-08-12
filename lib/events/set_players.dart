import 'package:kesakisat_mobile/models/player.dart';

import 'player_event.dart';

class SetPlayers extends PlayerEvent {
  List<Player> playerList;

  SetPlayers(List<Player> players) {
    playerList = players;
  }
}