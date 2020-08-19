import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/events/add_player.dart';
import 'package:kesakisat_mobile/events/update_player.dart';
import 'package:kesakisat_mobile/models/player.dart';

import 'db/database_provider.dart';

class PlayerForm extends StatefulWidget {
  final Player player;
  final int playerIndex;

  PlayerForm({this.player, this.playerIndex});

  @override
  State<StatefulWidget> createState() {
    return PlayerFormState();
  }
}

class PlayerFormState extends State<PlayerForm> {
  String _name;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Nimi'),
      maxLength: 20,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Nimi on pakollinen';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.player != null) {
      _name = widget.player.name;
    }
  }

  Widget editPlayer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text(
            "Päivitä",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            Player player = Player(
              name: _name,
            );

            DatabaseProvider.db.updatePlayer(widget.player.id, _name).then(
                  (storedPlayer) => BlocProvider.of<PlayerBloc>(context).add(
                    UpdatePlayer(widget.playerIndex, player),
                  ),
                );

            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text(
            "Peruuta",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget addPlayer() {
    return RaisedButton(
      child: Text(
        'Lisää',
        style: TextStyle(color: Colors.blue, fontSize: 16),
      ),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }

        _formKey.currentState.save();

        Player player = Player(name: _name.trim());

        DatabaseProvider.db.insertPlayer(player).then(
              (storedPlayer) => BlocProvider.of<PlayerBloc>(context).add(
                AddPlayer(storedPlayer),
              ),
            );

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.player == null ? "Lisää pelaaja" : "Muokkaa pelaajaa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        //margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              SizedBox(height: 20),
              widget.player == null ? addPlayer() : editPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}
