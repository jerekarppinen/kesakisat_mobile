import 'package:kesakisat_mobile/models/sport.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_SPORTS = "sports";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_IS_HIGH = "is_high"; // The highest score wins in distance and in score, the lowest wins in time measured

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