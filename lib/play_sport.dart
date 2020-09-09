import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/models/score.dart';
import 'package:kesakisat_mobile/models/sport.dart';
import 'package:kesakisat_mobile/services/player_state.dart';
import 'db/database_provider.dart';
import 'events/set_players.dart';

class PlaySport extends StatefulWidget {
  final Sport sport;

  const PlaySport({Key key, this.sport}) : super(key: key);

  @override
  _PlaySportState createState() => _PlaySportState();
}

class _PlaySportState extends State<PlaySport> {
  List<Score> _scoreList = [];

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getPlayers().then(
      (playerList) {
        BlocProvider.of<PlayerBloc>(context).add(SetPlayers(playerList));
      },
    );
    DatabaseProvider.db.getScoresBySport(widget.sport.id).then(
      (scoreList) {
        setState(() {
          _scoreList = scoreList;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "${widget.sport.name}, ${widget.sport.isHigh == 1 ? 'Pisteet / Pituus' : 'Aika'}")),
        body: Container(
          child: BlocConsumer<PlayerBloc, PlayerState>(
            builder: (context, state) {
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  Player player = state.players[index];

                  int _score;
                  _scoreList.forEach((value) {
                    if (value.playerId == player.id) {
                      _score = value.score;
                    }
                  });

                  return ListTile(
                    title: Text("${index + 1}. ${player.name}",
                        style: TextStyle(fontSize: 30)),
                    trailing: new Container(
                      width: 150.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: TextEditingController()
                                ..text =
                                    _score == null ? '' : _score.toString(),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(hintText: 'Tulos'),
                              onChanged: (value) => {
                                DatabaseProvider.db.insertScore(player.id,
                                    widget.sport.id, int.parse(value))
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: state.players.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(color: Colors.black),
              );
            },
            listener: (BuildContext context, sportList) {},
          ),
        ));
  }
}
