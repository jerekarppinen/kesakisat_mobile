import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/Player_bloc.dart';
import 'db/database_provider.dart';
import 'events/add_Player.dart';
import 'events/update_Player.dart';
import 'models/player.dart';

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
      maxLength: 15,
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
              print("form");
              return;
            }

            _formKey.currentState.save();

            Player player = Player(
              name: _name,
            );

            DatabaseProvider.db.updatePlayer(widget.player).then(
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

        Player player = Player(
          name: _name
        );

        DatabaseProvider.db.insertPlayer(player).then(
              (storedPlayer) => BlocProvider.of<PlayerBloc>(context).add(AddPlayer(storedPlayer),
          ),
        );

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _playerBloc = BlocProvider.of<PlayerBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Lisää pelaaja")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        //margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              SizedBox(height: 16),
              widget.player == null
                  ? RaisedButton(
                child: Text(
                  'Lisää',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Player player = Player(
                      name: _name
                  );

                  DatabaseProvider.db.insertPlayer(player).then(
                        (storedPlayer) => _playerBloc.add(AddPlayer(storedPlayer),
                    ),
                  );

                  Navigator.pop(context);
                },
              )
                  : editPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}