import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/events/delete_player.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/player_form.dart';
import 'package:kesakisat_mobile/states/player_state.dart';
import 'events/set_players.dart';

class PlayerList extends StatefulWidget {
  final DatabaseProvider provider;
  const PlayerList({Key key, this.provider}) : super(key: key);

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  PlayerBloc playerBloc;
  @override
  void initState() {
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    widget.provider.getPlayers().then(
      (playerList) {
        playerBloc.add(SetPlayers(playerList));
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
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlayerForm(player: player, playerIndex: index),
              ),
            ),
            child: Text("Päivitä"),
          ),
          TextButton(
            onPressed: () =>
                DatabaseProvider.db.deletePlayer(player.id).then((_) {
              BlocProvider.of<PlayerBloc>(context).add(
                DeletePlayer(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Poista"),
          ),
          TextButton(
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
        child: BlocBuilder<PlayerBloc, PlayerState>(
          bloc: playerBloc,
          builder: (context, state) {
            if (state.players.length == 0) {
              return Center(
                child: Text("Ei pelaajia.", style: TextStyle(fontSize: 30)),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Player player = state.players[index];
                return ListTile(
                    title: Text("${index + 1}. ${player.name}",
                        style: TextStyle(fontSize: 30)),
                    onTap: () => showPlayerDialog(context, player, index));
              },
              itemCount: state.players.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
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
