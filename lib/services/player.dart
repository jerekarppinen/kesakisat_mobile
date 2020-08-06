import "package:kesakisat_mobile/database.dart";
import "package:kesakisat_mobile/models/player.dart";

class PostService {
  Future<List<Player>> fetchPlayers() async {
    var db = DatabaseHelper();
    return db.getPlayers();
  }
}