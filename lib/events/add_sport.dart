import 'package:kesakisat_mobile/models/sport.dart';

import 'sport_event.dart';

class AddSport extends SportEvent {
  Sport newSport;

  AddSport(Sport sport) {
    newSport = sport;
  }
}