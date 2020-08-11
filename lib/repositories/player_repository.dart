import 'package:kesakisat_mobile/daos/player_dao.dart';
import 'package:kesakisat_mobile/models/player.dart';

class PlayerRepository {
  final playerDao = PlayerDao();

  Future getPlayers() => playerDao.getPlayers();
  Future addPlayer(Player player) => playerDao.addPlayer(player);
}