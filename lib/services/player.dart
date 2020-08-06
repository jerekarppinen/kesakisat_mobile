import "package:kesakisat_mobile/database.dart";
import "package:kesakisat_mobile/models/player.dart";

class PlayerService {
  Future<List<Player>> fetchPlayers() async {
    var db = DatabaseHelper();
    return db.getPlayers();
  }

  void addPlayer(String name) {
    var db = DatabaseHelper();
    db.addPlayer(name);
  }
}