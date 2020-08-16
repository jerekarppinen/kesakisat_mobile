import 'package:flutter/material.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/models/result.dart';
import 'package:kesakisat_mobile/models/score.dart';
import "package:collection/collection.dart";

class ResultList extends StatefulWidget {
  const ResultList({Key key}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getScores().then(
          (scoreList) {

            Map<String, List<Score>> groupBySportName = groupBy(scoreList, (Score obj) => obj.sportName);

            groupBySportName.forEach((sportName, scoresArray) {
              int isHigh = scoresArray[0].isHigh;

              // If sport has type high, sort players' scores desc
              if (isHigh == 1) {
                scoresArray.sort((a, b) => b.score.compareTo(a.score));
                // If sport has type low, sort players' scores asc
              } else if(isHigh == 0) {
                scoresArray.sort((a, b) => a.score.compareTo(b.score));
              }

              // The top player always gets 100 score
              int startPoints = 100;

              for(int i = 1; i <= scoresArray.length; i++) {
                Score score = scoresArray[i - 1];

                print("score: ${score.score}, points: ${startPoints}, player: ${score.playerName}, sport: ${score.sportName}");

                Result result = new Result(sportId: score.sportId, playerId: score.playerId, points: startPoints, score: score.score);

                DatabaseProvider.db.insertResult(result);

                if (i < scoresArray.length) {
                  if (scoresArray[i].score != score.score) {
                    startPoints--;
                  }
                }
              }
            });

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tulokset")),
      body: Container(
        child: Text("Tuloksia!")
      ),
    );
  }
}