import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/food_bloc.dart';
import 'db/database_provider.dart';
import 'events/add_food.dart';
import 'events/update_food.dart';
import 'models/food.dart';

enum SportsType {
  high,
  low
}

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({this.food, this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
  String _name;
  String _calories;
  bool _isVegan = false;
  SportsType _sportsType = SportsType.high;

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

  Widget _buildIsVegan() {

    return Column(
      children: [
        RadioListTile(
          title: const Text("Pisteet / Pituus"),
          value: SportsType.high,
          groupValue: _sportsType,
          onChanged: (SportsType value) {
            setState(() {
              _sportsType = value;
            });
            print("_sportsType: $_sportsType");
          },
        ),
        RadioListTile(
          title: const Text("Aika"),
          value: SportsType.low,
          groupValue: _sportsType,
          onChanged: (SportsType value) {
            setState(() {
              _sportsType = value;
            });
            print("_sportsType: $_sportsType");
          },
        )
    ],);
    return RadioListTile(
      title: const Text("Pisteet / Pituus"),
      value: SportsType.high,
      groupValue: _sportsType,
      onChanged: (SportsType value) {
        setState(() {
          _sportsType = value;
        });
      },
    );
    /*
    return SwitchListTile(
      title: Text("Vegan?", style: TextStyle(fontSize: 20)),
      value: _isVegan,
      onChanged: (bool newValue) => setState(() {
        _isVegan = newValue;
      }),
    );*/
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _name = widget.food.name;
      _calories = widget.food.calories;
      _isVegan = widget.food.isVegan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lisää laji")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              SizedBox(height: 16),
              _buildIsVegan(),
              SizedBox(height: 20),
              widget.food == null
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

                  Food food = Food(
                    name: _name,
                    calories: _calories,
                    isVegan: _isVegan,
                  );

                  DatabaseProvider.db.insert(food).then(
                        (storedFood) => BlocProvider.of<FoodBloc>(context).add(
                      AddFood(storedFood),
                    ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
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

                      Food food = Food(
                        name: _name,
                        calories: _calories,
                        isVegan: _isVegan,
                      );

                      DatabaseProvider.db.update(widget.food).then(
                            (storedFood) => BlocProvider.of<FoodBloc>(context).add(
                          UpdateFood(widget.foodIndex, food),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}