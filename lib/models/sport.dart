import 'package:kesakisat_mobile/db/database_provider.dart';

class Sport {
  int id;
  String name;
  int isHigh;

  Sport({this.id, this.name, this.isHigh});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.SPORTS_COLUMN_NAME: name,
      DatabaseProvider.SPORTS_COLUMN_IS_HIGH: isHigh
    };

    if (id != null) {
      map[DatabaseProvider.SPORTS_COLUMN_ID] = id;
    }

    return map;
  }

  Sport.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.SPORTS_COLUMN_ID];
    name = map[DatabaseProvider.SPORTS_COLUMN_NAME];
    isHigh = map[DatabaseProvider.SPORTS_COLUMN_IS_HIGH];
  }
}