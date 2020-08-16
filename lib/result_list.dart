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

            print("newList: ${groupBySportName['Tikanheitto'][3].score}");

        scoreList.forEach((score) {
          print("score.sportId: ${score.sportId}, score.sportsName: ${score.sportName}, score.playerId: ${score.playerId}, score.isHigh: ${score.isHigh}, score.score: ${score.score}, score.playerName: ${score.playerName}");



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