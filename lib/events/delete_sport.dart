import 'sport_event.dart';

class DeleteSport extends SportEvent {
  int sportIndex;

  DeleteSport(int index) {
    sportIndex = index;
  }
}