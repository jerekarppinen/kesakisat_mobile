import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/events/player_event.dart';
import 'package:kesakisat_mobile/models/player.dart';

class PlayerBloc extends Bloc<PlayerEvent, List<Player>> {
  @override
  List<Player> get initialState => List<Player>();

  @override
  Stream<List<Player>> mapEventToState(PlayerEvent event) async* {
    switch(event.eventType) {
      case EventType.add:
        List<Player> newState = List.from(state);
        if (event.player != null) {
          newState.add(event.player);
        }
        yield newState;
        break;
      case EventType.delete:
        List<Player> newState = List.from(state);
        newState.removeAt(event.playerIndex);
        yield newState;
        break;
      default:
        throw Exception("Event not found $event");
    }
  }

}