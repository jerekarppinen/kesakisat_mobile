import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/models/sport.dart';
import 'package:kesakisat_mobile/player_form.dart';
import 'db/database_provider.dart';
import 'events/set_players.dart';

class PlaySport extends StatefulWidget {

  final Sport sport;

  const PlaySport({Key key, this.sport}) : super(key: key);

  @override
  _PlaySportState createState() => _PlaySportState();
}

class _PlaySportState extends State<PlaySport> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getPlayers().then(
          (playerList) {
        BlocProvider.of<PlayerBloc>(context).add(SetPlayers(playerList));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire sport list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Laji: ${widget.sport.name}")),
      body: Container(
        child: BlocConsumer<PlayerBloc, List<Player>>(
          builder: (context, playerList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {

                Player player = playerList[index];
                return ListTile(
                    title: Text("${index + 1}. ${player.name} id: ${player.id}", style: TextStyle(fontSize: 30)),
                    onTap: () => print("player tapped"));
              },
              itemCount: playerList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, sportList) {},
        ),
      )
      );
  }
}