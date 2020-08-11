import 'player_event.dart';

class DeletePlayer extends PlayerEvent {
  int playerIndex;

  DeletePlayer(int index) {
    playerIndex = index;
  }
}