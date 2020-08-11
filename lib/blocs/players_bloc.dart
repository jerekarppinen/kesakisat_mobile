import 'dart:async';
import 'package:kesakisat_mobile/db/db_provider.dart';
import 'package:kesakisat_mobile/models/player.dart';

import 'bloc_provider.dart';

class PlayersBloc implements BlocBase {
  final _playersController = StreamController<List<Player>>.broadcast();

  StreamSink<List<Player>> get _inPlayers => _playersController.sink;

  Stream<List<Player>> get players => _playersController.stream;

  final _addPlayerController = StreamController<Player>.broadcast();
  StreamSink<Player> get inAddPlayer => _addPlayerController.sink;

  PlayersBloc() {
    getPlayers();
    print("getplayers");
    _addPlayerController.stream.listen(_handleAddPlayer);
  }

  @override
  void dispose() {
    _playersController.close();
    _addPlayerController.close();
  }

  void getPlayers() async {
    List<Player> players = await DBProvider.db.getPlayers();

    _inPlayers.add(players);
  }

  void _handleAddPlayer(Player player) async {
    await DBProvider.db.newPlayer(player);
    getPlayers();
  }
}

final bloc = PlayersBloc();