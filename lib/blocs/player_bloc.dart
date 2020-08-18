import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/events/add_player.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/events/player_event.dart';
import 'package:kesakisat_mobile/events/set_players.dart';
import 'package:kesakisat_mobile/events/update_player.dart';
import 'package:kesakisat_mobile/models/player.dart';

class PlayerBloc extends Bloc<PlayerEvent, List<Player>> {
  PlayerBloc(List<Player> initialState) : super();

  List<Player> get initialState => List<Player>();

  @override
  Stream<List<Player>> mapEventToState(PlayerEvent event) async* {
    if (event is SetPlayers) {
      yield event.playerList;
    } else if (event is AddPlayer) {
      List<Player> newState = List.from(state);
      if (event.newPlayer != null) {
        newState.add(event.newPlayer);
      }
      yield newState;
    } else if (event is DeletePlayer) {
      List<Player> newState = List.from(state);
      newState.removeAt(event.playerIndex);
      yield newState;
    } else if (event is UpdatePlayer) {
      List<Player> newState = List.from(state);
      newState[event.playerIndex] = event.newPlayer;
      yield newState;
    }
  }
}
