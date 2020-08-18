import 'package:kesakisat_mobile/models/score.dart';

class Result {
  int sportId;
  int playerId;
  int points;
  int score;
  String playerName;
  String sportName;

  Result({ this.sportId, this.playerId, this.points, this.score });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'player_id': playerId,
      'sport_id': sportId,
      'points': points,
      'score': score
    };

    return map;
  }

  Result.fromMap(Map<String, dynamic> map) {
    playerId = map['player_id'];
    sportId = map['sport_id'];
    points = map['points'];
    score = map['score'];
    playerName = map['player_name'];
    sportName = map['sport_name'];
  }
}