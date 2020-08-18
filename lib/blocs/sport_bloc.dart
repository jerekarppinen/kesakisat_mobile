import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/events/add_sport.dart';
import 'package:kesakisat_mobile/events/delete_sport.dart';
import 'package:kesakisat_mobile/events/sport_event.dart';
import 'package:kesakisat_mobile/events/set_sports.dart';
import 'package:kesakisat_mobile/events/update_sport.dart';
import 'package:kesakisat_mobile/models/sport.dart';

class SportBloc extends Bloc<SportEvent, List<Sport>> {
  SportBloc(List<Sport> initialState) : super();

  List<Sport> get initialState => List<Sport>();

  @override
  Stream<List<Sport>> mapEventToState(SportEvent event) async* {
    if (event is SetSports) {
      yield event.sportList;
    } else if (event is AddSport) {
      List<Sport> newState = List.from(state);
      if (event.newSport != null) {
        newState.add(event.newSport);
      }
      yield newState;
    } else if (event is DeleteSport) {
      List<Sport> newState = List.from(state);
      newState.removeAt(event.sportIndex);
      yield newState;
    } else if (event is UpdateSport) {
      List<Sport> newState = List.from(state);
      newState[event.sportIndex] = event.newSport;
      yield newState;
    }
  }
}