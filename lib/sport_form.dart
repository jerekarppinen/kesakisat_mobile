import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/sport_bloc.dart';
import 'db/database_provider.dart';
import 'events/add_sport.dart';
import 'events/update_sport.dart';
import 'models/sport.dart';

class SportForm extends StatefulWidget {
  final Sport sport;
  final int sportIndex;

  SportForm({this.sport, this.sportIndex});

  @override
  State<StatefulWidget> createState() {
    return PlayerFormState();
  }
}

class SportsType {
  final int _key;
  final String _value;

  SportsType(this._key, this._value);
}

class PlayerFormState extends State<SportForm> {
  int _isHigh = 1;

  final _sportsOptions = [
    SportsType(1, "high"),
    SportsType(0, "low"),
  ];

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
        _name = value.trim();
      },
    );
  }

  Widget _buildSportType() {
    return Column(
      children: _sportsOptions
          .map((sportValue) => RadioListTile(
                groupValue: _isHigh,
                title: Text(
                    sportValue._value == 'high' ? 'Pisteet / Pituus' : 'Aika'),
                value: sportValue._key,
                onChanged: (val) {
                  setState(() {
                    _isHigh = val;
                  });
                },
              ))
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.sport != null) {
      _name = widget.sport.name;
      // _isHigh = widget.sport.;
    }
  }

  Widget editSport() {
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

            Sport sport = Sport(
              name: _name,
              isHigh: _isHigh,
            );

            DatabaseProvider.db
                .updateSport(widget.sport.id, _name, _isHigh)
                .then(
                  (storedSport) => BlocProvider.of<SportBloc>(context).add(
                    UpdateSport(widget.sportIndex, sport),
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

  Widget addSport() {
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

        Sport sport = Sport(
          name: _name,
          isHigh: _isHigh,
        );

        DatabaseProvider.db.insert(sport).then(
              (storedSport) => BlocProvider.of<SportBloc>(context).add(
                AddSport(storedSport),
              ),
            );

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lisää laji")),
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
              _buildSportType(),
              SizedBox(height: 20),
              widget.sport == null ? addSport() : editSport(),
            ],
          ),
        ),
      ),
    );
  }
}
