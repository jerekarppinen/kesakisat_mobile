import 'package:kesakisat_mobile/db/database_provider.dart';

class Sport {
  int id;
  String name;
  int isHigh;

  Sport({this.id, this.name, this.isHigh});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_IS_HIGH: isHigh
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Sport.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    isHigh = map[DatabaseProvider.COLUMN_IS_HIGH];
  }
}