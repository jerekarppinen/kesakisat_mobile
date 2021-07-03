import 'package:equatable/equatable.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';

class Player extends Equatable {
  int id;
  String name;

  Player({this.id, this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.PLAYER_COLUMN_NAME: name,
    };

    if (id != null) {
      map[DatabaseProvider.SPORTS_COLUMN_ID] = id;
    }

    return map;
  }

  Player.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.SPORTS_COLUMN_ID];
    name = map[DatabaseProvider.SPORTS_COLUMN_NAME];
  }

  @override
  List<Object> get props => [
        this.id,
        this.name,
      ];
}
