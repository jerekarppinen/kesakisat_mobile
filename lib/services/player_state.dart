import 'package:equatable/equatable.dart';
import 'package:kesakisat_mobile/models/player.dart';

abstract class PlayerState extends Equatable {
  final List<Player> players;

  PlayerState({this.players});
}

class PlayerInitialState extends PlayerState {
  PlayerInitialState() : super(players: []);

  @override
  List<Object> get props => [super.players];
}

class PlayersSetState extends PlayerState {
  PlayersSetState({List<Player> players}) : super(players: players);
  @override
  List<Object> get props => [players];
}

class PlayerDeletedState extends PlayerState {
  PlayerDeletedState({List<Player> players}) : super(players: players);
  @override
  List<Object> get props => [players];
}

class PlayerUpdatedState extends PlayerState {
  PlayerUpdatedState({List<Player> players}) : super(players: players);
  @override
  List<Object> get props => [players];
}
