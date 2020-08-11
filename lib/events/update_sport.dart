import 'package:kesakisat_mobile/models/sport.dart';

import 'sport_event.dart';

class UpdateSport extends SportEvent {
  Sport newSport;
  int sportIndex;

  UpdateSport(int index, Sport sport) {
    newSport = sport;
    sportIndex = index;
  }
}