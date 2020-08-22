import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/player_form.dart';
import 'db/database_provider.dart';
import 'events/set_players.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({Key key}) : super(key: key);

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getPlayers().then(
      (playerList) {
        BlocProvider.of<PlayerBloc>(context).add(SetPlayers(playerList));
      },
    );
  }

  showPlayerDialog(BuildContext context, Player player, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          player.name,
          textAlign: TextAlign.center,
        ),
        content: Text(""),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlayerForm(player: player, playerIndex: index),
              ),
            ),
            child: Text("Päivitä"),
          ),
          FlatButton(
            onPressed: () =>
                DatabaseProvider.db.deletePlayer(player.id).then((_) {
              BlocProvider.of<PlayerBloc>(context).add(
                DeletePlayer(index),
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
      appBar: AppBar(title: Text("Pelaajat")),
      body: Container(
        child: BlocConsumer<PlayerBloc, List<Player>>(
          builder: (context, playerList) {
            if (playerList.length == 0) {
              return Center(
                child: Text("Ei pelaajia.", style: TextStyle(fontSize: 30)),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Player player = playerList[index];
                return ListTile(
                    title: Text("${index + 1}. ${player.name}",
                        style: TextStyle(fontSize: 30)),
                    onTap: () => showPlayerDialog(context, player, index));
              },
              itemCount: playerList.length,
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
          MaterialPageRoute(builder: (BuildContext context) => PlayerForm()),
        ),
      ),
    );
  }
}
