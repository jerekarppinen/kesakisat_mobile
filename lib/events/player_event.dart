import 'package:kesakisat_mobile/models/player.dart';

enum EventType{
  add, delete
}

class PlayerEvent {
  Player player;
  int playerIndex;
  EventType eventType;

  PlayerEvent.add(Player player) {
    this.eventType = EventType.add;
    this.player = player;
  }

  PlayerEvent.delete(int index) {
    this.eventType = EventType.delete;
    this.playerIndex = index;
  }
}