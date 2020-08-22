import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/models/result.dart';
import 'package:kesakisat_mobile/models/score.dart';
import "package:collection/collection.dart";

class ResultService {
  _setPointsForEachPlayer(Map<String, List<Score>> groupBySportName) {
    groupBySportName.forEach((sportName, scoresArray) {
      int isHigh = scoresArray[0].isHigh;

      // If sport has type high, sort players' scores desc
      if (isHigh == 1) {
        scoresArray.sort((a, b) => b.score.compareTo(a.score));
        // If sport has type low, sort players' scores asc
      } else if (isHigh == 0) {
        scoresArray.sort((a, b) => a.score.compareTo(b.score));
      }

      // The top player always gets 100 score
      int startPoints = 100;

      for (int i = 1; i <= scoresArray.length; i++) {
        Score score = scoresArray[i - 1];

        Result result = new Result(
            sportId: score.sportId,
            playerId: score.playerId,
            points: startPoints,
            score: score.score);

        DatabaseProvider.db.insertResult(result);

        if (i < scoresArray.length) {
          if (scoresArray[i].score != score.score) {
            startPoints--;
          }
        }
      }
    });
  }

  Future<Map<String, int>> getResultsCalculated() async {
    Map _totalPointsMap = Map<String, int>();

    var scoreList = await DatabaseProvider.db.getScores();

    Map<String, List<Score>> groupBySportName =
        groupBy(scoreList, (Score obj) => obj.sportName);

    _setPointsForEachPlayer(groupBySportName);

    var resultList = await DatabaseProvider.db.getResults();

    Map<String, List<Result>> groupByPlayer =
        groupBy(resultList, (Result obj) => obj.playerName);

    groupByPlayer.forEach((playerName, scores) {
      int playerPointsSum = scores.fold(0, (sum, item) => sum + item.points);
      _totalPointsMap.putIfAbsent(playerName, () => playerPointsSum);
    });

    return _totalPointsMap;
  }
}
