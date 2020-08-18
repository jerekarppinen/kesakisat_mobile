import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kesakisat_mobile/services/score_service.dart';

class ResultList extends StatefulWidget {
  const ResultList({Key key}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {

  ScoreService _scoreService = new ScoreService();

  bool _showFloatingActionButton = false;

  @override
  void initState() {
    super.initState();
  }

  Widget getFloatingActionButton() {
    if (!_showFloatingActionButton) return Container();
    return FloatingActionButton.extended(
      label: Text("Tyhjennä"),
      icon: Icon(Icons.delete),
      onPressed: () { print("pressed!"); },
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tulokset")),
      body: Container(
        child: FutureBuilder<Map<String, int>>(
          future: _scoreService.getScoresCalculated(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (!snapshot.hasData) {
              return Dialog(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text("Lasketaan...")
                  ],
                )
              );
            }

            if (snapshot.data.length == 0) {
              return Center(
                  child: Text(
                      "Ei tuloksia",
                    style: TextStyle(
                      fontSize: 30
                    ),
                  )
              );
            }

            var data = snapshot.data;

            if (data.length > 0) {
              _showFloatingActionButton = true;
            }

            // https://stackoverflow.com/questions/30620546/how-to-sort-map-value
            var sortedKeys = data.keys.toList(growable:false)
              ..sort((k1, k2) => data[k2].compareTo(data[k1]));
            LinkedHashMap sortedMap = new LinkedHashMap
                .fromIterable(sortedKeys, key: (k) => k, value: (k) => data[k]);

            return ListView.builder(
              itemCount: sortedMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = sortedMap.keys.elementAt(index);
                return new Column(
                  children: [
                    ListTile(
                      title: Text("${index+1}: $key"),
                      subtitle: Text(sortedMap[key].toString()),
                    ),
                    Divider(height: 2.0)
                  ],
                );
              },
            );
          },
        )
      ),
      floatingActionButton: getFloatingActionButton(),
    );
  }
}