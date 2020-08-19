import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/services/score_service.dart';

class ResultList extends StatefulWidget {
  const ResultList({Key key}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {

  ScoreService _scoreService = new ScoreService();

  @override
  void initState() {
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Peruuta"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Jatka"),
      onPressed:  () {
        DatabaseProvider.db.deleteScoresAndResults().then((result) {
          Navigator.pop(context);
          setState(() {}); // Refresh the page
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Varoitus"),
      content: Text("Tämä poistaa kaikki merkatut pisteet."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
                      title: Text("$key"),
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Tyhjennä"),
        icon: Icon(Icons.delete),
        onPressed: () {
          showAlertDialog(context);
          },
        backgroundColor: Colors.red,
      ),
    );
  }
}