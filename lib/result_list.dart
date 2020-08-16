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

            var groupBySportName = groupBy(scoreList, (Score obj) => obj.sportName);

            scoreList.forEach((score) {
              print("sportName: ${score.sportName}, playerName: ${score.playerName}, score: ${score.score}, isHigh: ${score.isHigh}");
            });

            print("");

            groupBySportName.forEach((sportName, scoresArray) {
              print("sportName: $sportName, scoresArray: $scoresArray");
              
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