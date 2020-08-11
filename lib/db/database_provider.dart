import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/models/sport.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_SPORTS = "sports";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_IS_HIGH = "is_high"; // The highest score wins in distance and in score, the lowest wins in time measured


  static const String TABLE_PLAYERS = "players";
  static const String PLAYER_COLUMN_ID = "id";
  static const String PLAYER_COLUMN_NAME = "name";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'sportsDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating $TABLE_SPORTS table");

        await database.execute(
          "CREATE TABLE $TABLE_SPORTS ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_IS_HIGH INTEGER"
              ")",
        );

        print("Creating $TABLE_PLAYERS table");

        await database.execute(
          "CREATE TABLE $TABLE_PLAYERS ("
              "$PLAYER_COLUMN_ID INTEGER PRIMARY KEY,"
              "$PLAYER_COLUMN_NAME TEXT"
              ")",
        );
      },
    );
  }

  Future<List<Sport>> getSports() async {
    final db = await database;

    var sports = await db
        .query(TABLE_SPORTS, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_IS_HIGH]);

    List<Sport> sportList = List<Sport>();

    sports.forEach((currentSport) {
      Sport sport = Sport.fromMap(currentSport);

      sportList.add(sport);
    });

    return sportList;
  }

  Future<List<Player>> getPlayers() async {
    final db = await database;

    var players = await db
        .query(TABLE_PLAYERS, columns: [COLUMN_ID, COLUMN_NAME]);

    List<Player> playerList = List<Player>();

    players.forEach((currentPlayer) {
      Player player = Player.fromMap(currentPlayer);

      playerList.add(player);
    });

    return playerList;
  }

  Future<Sport> insert(Sport sport) async {
    final db = await database;
    sport.id = await db.insert(TABLE_SPORTS, sport.toMap());
    return sport;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_SPORTS,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Sport sport) async {
    final db = await database;

    return await db.update(
      TABLE_SPORTS,
      sport.toMap(),
      where: "id = ?",
      whereArgs: [sport.id],
    );
  }
}