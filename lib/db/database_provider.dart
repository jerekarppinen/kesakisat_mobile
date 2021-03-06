import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/models/result.dart';
import 'package:kesakisat_mobile/models/score.dart';
import 'package:kesakisat_mobile/models/sport.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_SPORTS = "sports";
  static const String SPORTS_COLUMN_ID = "id";
  static const String SPORTS_COLUMN_NAME = "name";
  static const String SPORTS_COLUMN_IS_HIGH =
      "is_high"; // The highest score wins in distance and in score, the lowest wins in time measured

  static const String TABLE_PLAYERS = "players";
  static const String PLAYER_COLUMN_ID = "id";
  static const String PLAYER_COLUMN_NAME = "name";

  static const String TABLE_SPORT_SCORE = "sport_scores";
  static const String SCORE_SPORT_ID = "sport_id";
  static const String SCORE_PLAYER_ID = "player_id";
  static const String SCORE_SCORE = "score";

  static const String TABLE_SPORT_RESULTS = "sport_results";
  static const String SPORT_RESULTS_COLUMN_PLAYER_ID = "player_id";
  static const String SPORT_RESULTS_COLUMN_SPORT_ID = "sport_id";
  static const String SPORT_RESULTS_COLUMN_SCORE = "score";
  static const String SPORT_RESULTS_COLUMN_POINTS = "points";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
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
          "$SPORTS_COLUMN_ID INTEGER PRIMARY KEY,"
          "$SPORTS_COLUMN_NAME TEXT,"
          "$SPORTS_COLUMN_IS_HIGH INTEGER"
          ")",
        );

        print("Creating $TABLE_PLAYERS table");

        await database.execute(
          "CREATE TABLE $TABLE_PLAYERS ("
          "$PLAYER_COLUMN_ID INTEGER PRIMARY KEY,"
          "$PLAYER_COLUMN_NAME TEXT"
          ")",
        );

        print("Creating $TABLE_SPORT_SCORE table");

        await database.execute("CREATE TABLE $TABLE_SPORT_SCORE ("
            "$SCORE_PLAYER_ID INTEGER,"
            "$SCORE_SPORT_ID INTEGER,"
            "$SCORE_SCORE INTEGER,"
            "PRIMARY KEY ($SCORE_PLAYER_ID, $SCORE_SPORT_ID)"
            ")");

        print("Creating $TABLE_SPORT_RESULTS table");

        await database.execute("CREATE TABLE $TABLE_SPORT_RESULTS ("
            "$SPORT_RESULTS_COLUMN_PLAYER_ID INTEGER,"
            "$SPORT_RESULTS_COLUMN_SPORT_ID INTEGER,"
            "$SPORT_RESULTS_COLUMN_SCORE INTEGER,"
            "$SPORT_RESULTS_COLUMN_POINTS INTEGER,"
            "PRIMARY KEY ($SPORT_RESULTS_COLUMN_PLAYER_ID, $SPORT_RESULTS_COLUMN_SPORT_ID)"
            ")");
      },
    );
  }

  Future<List<Sport>> getSports() async {
    final db = await database;

    var sports = await db
        .query(TABLE_SPORTS, columns: [SPORTS_COLUMN_ID, SPORTS_COLUMN_NAME, SPORTS_COLUMN_IS_HIGH]);

    List<Sport> sportList = List<Sport>();

    sports.forEach((currentSport) {
      Sport sport = Sport.fromMap(currentSport);

      sportList.add(sport);
    });

    return sportList;
  }

  Future<List<Score>> getScores() async {
    final db = await database;

    var scores = await db.rawQuery(
        "SELECT "
            "$TABLE_SPORTS.name as sportName, "
            "$SCORE_PLAYER_ID, "
            "$SCORE_SPORT_ID, "
            "$SCORE_SCORE, "
            "$TABLE_SPORTS.is_High, "
            "$TABLE_PLAYERS.name as playerName "
        "FROM "
            "$TABLE_SPORT_SCORE "
        "JOIN "
            "$TABLE_SPORTS ON $TABLE_SPORT_SCORE.sport_id = $TABLE_SPORTS.id "
        "JOIN "
            "$TABLE_PLAYERS ON $TABLE_SPORT_SCORE.player_id = $TABLE_PLAYERS.id "
        "ORDER BY sport_id ASC");

    List<Score> scoreList = List<Score>();
    scores.forEach((currentScore) {
      Score score = Score.fromMap(currentScore);
      scoreList.add(score);
    });

    return scoreList;
  }

  Future<List<Score>> getScoresBySport(int sportId) async {
    final db = await database;

    var scores = await db.rawQuery(
        "SELECT "
            "$TABLE_SPORTS.name,"
            "$SCORE_PLAYER_ID,"
            "$SCORE_SPORT_ID,"
            "$SCORE_SCORE,"
            "$TABLE_SPORTS.is_High "
        "FROM "
            "$TABLE_SPORT_SCORE "
        "JOIN "
        "$TABLE_SPORTS ON $TABLE_SPORT_SCORE.sport_id = $TABLE_SPORTS.id "
            "WHERE $TABLE_SPORT_SCORE.sport_id = $sportId");

    List<Score> scoreList = List<Score>();
    scores.forEach((currentScore) {
      Score score = Score.fromMap(currentScore);
      scoreList.add(score);
    });

    return scoreList;
  }

  Future<List<Player>> getPlayers() async {
    final db = await database;

    var players =
        await db.query(TABLE_PLAYERS, columns: [SPORTS_COLUMN_ID, SPORTS_COLUMN_NAME]);

    List<Player> playerList = List<Player>();

    players.forEach((currentPlayer) {
      Player player = Player.fromMap(currentPlayer);

      playerList.add(player);
    });

    return playerList;
  }

  Future<Sport> insertSport(Sport sport) async {
    final db = await database;
    sport.id = await db.insert(TABLE_SPORTS, sport.toMap());
    return sport;
  }

  Future<Player> insertPlayer(Player player) async {
    final db = await database;
    player.id = await db.insert(TABLE_PLAYERS, player.toMap());
    return player;
  }

  Future<List<Score>> insertScore(int playerId, int sportId, int score) async {
    print("playerId: $playerId, sportId: $sportId, score: $score");
    final db = await database;

    await db.rawQuery(
        "REPLACE INTO " +
            "$TABLE_SPORT_SCORE "
                "($SCORE_PLAYER_ID, $SCORE_SPORT_ID, $SCORE_SCORE)" +
        "VALUES ($playerId, $sportId, $score)");

    var scores = await db.rawQuery(
        "SELECT "
            "$TABLE_SPORTS.name,"
            "$SCORE_PLAYER_ID,"
            "$SCORE_SPORT_ID,"
            "$SCORE_SCORE,"
            "$TABLE_SPORTS.is_High "
        "FROM "
            "$TABLE_SPORT_SCORE "
        "JOIN $TABLE_SPORTS "
            "ON $TABLE_SPORT_SCORE.sport_id = $TABLE_SPORTS.id "
            "WHERE $TABLE_SPORT_SCORE.sport_id = $sportId");

    List<Score> scoreList = List<Score>();
    scores.forEach((currentScore) {
      Score score = Score.fromMap(currentScore);
      scoreList.add(score);
    });

    return scoreList;
  }

  Future<bool> deleteScoresAndResults() async {
    final db = await database;
    var tableScore = await db.delete(TABLE_SPORT_SCORE);
    var tableResults = await db.delete(TABLE_SPORT_RESULTS);
    return (tableResults == 1 && tableScore == 1);
  }

  Future<List<Result>> getResults() async {
    final db = await database;
    var results = await db.rawQuery(
        "SELECT "
            "$SPORT_RESULTS_COLUMN_PLAYER_ID, "
            "$SPORT_RESULTS_COLUMN_SPORT_ID, "
            "$SPORT_RESULTS_COLUMN_POINTS, "
            "$SPORT_RESULTS_COLUMN_SCORE, "
            "$TABLE_PLAYERS.name AS player_name, "
            "$TABLE_SPORTS.name AS sportName "
        "FROM "
            "$TABLE_SPORT_RESULTS "
        "JOIN $TABLE_PLAYERS ON players.id = $TABLE_SPORT_RESULTS.player_id "
        "JOIN $TABLE_SPORTS ON sports.id = $TABLE_SPORT_RESULTS.sport_id"
    );

    List<Result> resultList = List<Result>();

    results.forEach((currentResult) {
      Result result = Result.fromMap(currentResult);

      resultList.add(result);
    });

    return resultList;
  }

  Future<Result> insertResult(Result result) async {
    final db = await database;
    await db.rawQuery(
        "REPLACE INTO "
            "$TABLE_SPORT_RESULTS ($SPORT_RESULTS_COLUMN_PLAYER_ID, $SPORT_RESULTS_COLUMN_SPORT_ID, $SPORT_RESULTS_COLUMN_POINTS, $SPORT_RESULTS_COLUMN_SCORE) "
            "VALUES (${result.playerId}, ${result.sportId}, ${result.points}, ${result.score})");
    return result;
  }

  Future<int> deleteSport(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_SPORTS,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deletePlayer(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_PLAYERS,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateSport(Sport sport) async {
    final db = await database;

    return await db.update(
      TABLE_SPORTS,
      sport.toMap(),
      where: "id = ?",
      whereArgs: [sport.id],
    );
  }

  Future<int> updatePlayer(int playerId, String playerName) async {
    Player player = new Player(id: playerId, name: playerName);

    final db = await database;

    return await db.update(
      TABLE_PLAYERS,
      player.toMap(),
      where: "id = ?",
      whereArgs: [player.id],
    );
  }
}
