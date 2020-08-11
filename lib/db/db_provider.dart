import 'package:kesakisat_mobile/models/player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE players (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
    );
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'olympics.db');

    return await openDatabase(dbPath, version: 1, onCreate: _onCreate, onOpen: (db) async {});
  }

  getPlayers() async {
    final db = await database;
    var res = await db.query('players');
    List<Player> players = res.isNotEmpty ? res.map((player) => Player.fromJson(player)).toList() : [];
    return players;
  }

  newPlayer(Player player) async {
    final db = await database;
    var res = await db.insert('players', player.toJson());
    return res;
  }

}