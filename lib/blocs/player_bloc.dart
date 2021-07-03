import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/events/add_player.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/events/player_event.dart';
import 'package:kesakisat_mobile/events/set_players.dart';
import 'package:kesakisat_mobile/events/update_player.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/states/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super();

  PlayerState get initialState => PlayerInitialState();

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    if (event is SetPlayers) {
      yield PlayersSetState(players: event.playerList);
    } else if (event is AddPlayer) {
      List<Player> players = state.players;
      if (event.newPlayer != null) {
        players.add(event.newPlayer);
        yield PlayersSetState(players: players);
      }
    } else if (event is DeletePlayer) {
      List<Player> players = state.players;
      players.removeAt(event.playerIndex);
      yield PlayerDeletedState(players: players);
    } else if (event is UpdatePlayer) {
      List<Player> players = state.players;
      players[event.playerIndex] = event.newPlayer;
      yield PlayerUpdatedState(players: players);
    }
  }
}
