import 'package:flutter/material.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
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

            scoreList.forEach((score) {
              print("sportName: ${score.sportName}, playerName: ${score.playerName}, score: ${score.score}, isHigh: ${score.isHigh}");
            });

            print("");

            Map<String, List<Score>> groupBySportName = groupBy(scoreList, (Score obj) => obj.sportName);

            groupBySportName.forEach((sportName, scoresArray) {
              print("sportName: $sportName, scoresArray: $scoresArray");
              print("isHigh: ${scoresArray[0].isHigh}");
              int isHigh = scoresArray[0].isHigh;

              if (isHigh == 1) {
                scoresArray.sort((a, b) => b.score.compareTo(a.score));
              } else if(isHigh == 0) {
                scoresArray.sort((a, b) => a.score.compareTo(b.score));
              }

              int startPoints = 100;
              scoresArray.forEach((score) {
                print("score: ${score.score}, points: ${startPoints--}, player: ${score.playerName}, sport: ${score.sportName}");
              });

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