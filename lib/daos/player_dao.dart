import 'package:kesakisat_mobile/db/db_provider.dart';

import '../models/player.dart';

class PlayerDao {
  final dbProvider = DBProvider.db;

  Future<int> addPlayer(Player player) async {
    print(123);
    final db = await dbProvider.database;
    var result = db.insert('players', player.toJson());
    return result;
  }

  Future<List<Player>> getPlayers() async {
    final db = await dbProvider.database;
    var res = await db.query('players');
    List<Player> players = res.isNotEmpty ? res.map((player) => Player.fromJson(player)).toList() : [];
    return players;
  }
}