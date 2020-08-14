import 'package:kesakisat_mobile/db/database_provider.dart';

class Score {
  int playerId;
  int sportId;
  int score;

  Score({this.playerId, this.sportId, this.score});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.SPORT_RESULTS_COLUMN_PLAYER_ID: playerId,
      DatabaseProvider.SPORT_RESULTS_COLUMN_SPORT_ID: sportId,
      DatabaseProvider.SPORT_RESULTS_COLUMN_SCORE: score
    };

    /*
    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    } */

    return map;
  }

  Score.fromMap(Map<String, dynamic> map) {
    playerId = map[DatabaseProvider.SPORT_RESULTS_COLUMN_PLAYER_ID];
    sportId = map[DatabaseProvider.SPORT_RESULTS_COLUMN_SPORT_ID];
    score = map[DatabaseProvider.SPORT_RESULTS_COLUMN_SCORE];
  }
}