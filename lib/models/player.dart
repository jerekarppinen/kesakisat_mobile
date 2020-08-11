import 'package:kesakisat_mobile/db/database_provider.dart';

class Player {
  int id;
  String name;

  Player({this.id, this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.PLAYER_COLUMN_NAME: name,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Player.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
  }
}