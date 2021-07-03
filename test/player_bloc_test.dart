import 'package:flutter_test/flutter_test.dart';

import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/events/set_players.dart';
import 'package:kesakisat_mobile/events/update_player.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/states/player_state.dart';

void main() {
  test('Initialize player bloc', () async {
    final playerBloc = PlayerBloc();
    expectLater(
      playerBloc,
      emits(
        PlayerInitialState(),
      ),
    );
  });

  test('Set empty players', () async {
    final playerBloc = PlayerBloc();
    playerBloc.add(SetPlayers([]));
    expectLater(
      playerBloc,
      emitsInOrder(
        [
          playerBloc.initialState,
          PlayersSetState(players: []),
        ],
      ),
    );
  });

  test('Set multiple players', () async {
    final playerBloc = PlayerBloc();
    final players = [
      Player(id: 1, name: "eka"),
      Player(id: 2, name: "toka"),
    ];
    playerBloc.add(SetPlayers(players));
    expectLater(
      playerBloc,
      emitsInOrder(
        [
          playerBloc.initialState,
          PlayersSetState(players: players),
        ],
      ),
    );
  });

  test('Delete player', () async {
    final playerBloc = PlayerBloc();
    final players = [
      Player(id: 1, name: "eka"),
      Player(id: 2, name: "toke"),
    ];
    playerBloc.add(SetPlayers(players));
    playerBloc.add(DeletePlayer(1));
    expectLater(
      playerBloc,
      emitsInOrder(
        [
          playerBloc.initialState,
          PlayersSetState(players: players),
          PlayerDeletedState(players: [Player(id: 1, name: "eka")]),
        ],
      ),
    );
  });

  test('Update player', () async {
    final playerBloc = PlayerBloc();
    final players = [
      Player(id: 1, name: "eka"),
      Player(id: 2, name: "toke"),
    ];
    playerBloc.add(SetPlayers(players));
    playerBloc.add(UpdatePlayer(
      1,
      Player(id: 2, name: "toka"),
    ));
    expectLater(
      playerBloc,
      emitsInOrder(
        [
          playerBloc.initialState,
          PlayersSetState(players: players),
          PlayerUpdatedState(players: [
            Player(id: 1, name: "eka"),
            Player(id: 2, name: "toka"),
          ]),
        ],
      ),
    );
  });
}
