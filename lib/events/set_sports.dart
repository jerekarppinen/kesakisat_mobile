import 'package:kesakisat_mobile/models/sport.dart';

import 'sport_event.dart';

class SetSports extends SportEvent {
  List<Sport> sportList;

  SetSports(List<Sport> sports) {
    sportList = sports;
  }
}