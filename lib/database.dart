import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'models/player.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'olympics.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE players (id INTEGER PRIMARY KEY, name TEXT)"
    );
  }

  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM players ORDER BY id DESC;");
    List<Player> players = new List();
    for (int i = 0; i < list.length; i++) {
      var player = new Player(id: list[i]['id'], name: list[i]['name']);
      players.add(player);
    }
    return players;
  }

  Future<int> savePlayer(Player player) async {
    var dbClient = await db;
    int res = 0;
    try {
      res = await dbClient.insert("players", player.toMap());
    } catch(e) {
      update(player);
    }
    return res;
  }

  Future<bool> update(Player player) async {
    var dbClient = await db;
    int res =   await dbClient.update("players", player.toMap(),
        where: "id = ?", whereArgs: <int>[player.id]);
    return res > 0 ? true : false;
  }



}