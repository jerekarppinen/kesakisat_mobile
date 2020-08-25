import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/models/inserted_score.dart';
import 'package:kesakisat_mobile/models/sport.dart';
import 'package:kesakisat_mobile/play_sport.dart';

import 'blocs/sport_bloc.dart';
import 'db/database_provider.dart';
import 'events/delete_sport.dart';
import 'events/set_sports.dart';
import 'sport_form.dart';
import 'models/sport.dart';

class SportList extends StatefulWidget {
  const SportList({Key key}) : super(key: key);

  @override
  _SportListState createState() => _SportListState();
}

class _SportListState extends State<SportList> {

  int _numberOfPlayers;
  List<InsertedScore> _insertedScores = [];

  @override
  void initState() {
    super.initState();

    DatabaseProvider.db.getSports().then(
      (sportList) {
        BlocProvider.of<SportBloc>(context).add(SetSports(sportList));
      },
    );

    DatabaseProvider.db.getNumberOfScoresBySport().then((values) {
      final int numberOfPlayers = values[0].numberOfPlayers;
      setState(() {
        _numberOfPlayers = numberOfPlayers;
        _insertedScores = values;
      });
    });
  }

  showSportDialog(BuildContext context, Sport sport, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          sport.name,
          textAlign: TextAlign.center,
        ),
        content: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.white)
          ),
          color: Colors.green,
          textColor: Colors.white,
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PlaySport(sport: sport),
            ),
          ),
          child: Text(
            "Pelaa",
            style: TextStyle(fontSize: 20),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SportForm(sport: sport, sportIndex: index),
              ),
            ),
            child: Text(
              "Päivitä",
            ),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.deleteSport(sport.id).then((_) {
              BlocProvider.of<SportBloc>(context).add(
                DeleteSport(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Poista"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Peruuta"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lajit"),
      ),
      body: Container(
        child: BlocConsumer<SportBloc, List<Sport>>(
          builder: (context, sportList) {
            if (sportList.length == 0) {
              return Center(
                child: Text("Ei lajeja.", style: TextStyle(fontSize: 30)),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Sport sport = sportList[index];
                int numberOfScores = 0;

                if (_insertedScores != null) {
                  _insertedScores.forEach((element) {
                    if(element.sportId == sport.id) {
                      numberOfScores = element.numberOfScores;
                    }
                  });
                }

                return ListTile(
                    trailing: _numberOfPlayers != null ? Text("$numberOfScores/$_numberOfPlayers") : Text(""),
                    title: Text("${index + 1}. ${sport.name}",
                        style: TextStyle(fontSize: 30)),
                    subtitle: Text(
                      "Tyyppi: ${sport.isHigh == 1 ? 'Pisteet / Pituus' : 'Aika'}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showSportDialog(context, sport, index));
              },
              itemCount: sportList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, sportList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => SportForm()),
        ),
      ),
    );
  }
}
