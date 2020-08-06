class Player {
  int id;
  String name;

  Player({this.id, this.name});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> event = <String, dynamic>{
      'id': this.id,
      'name': this.name
    };
    return event;
  }
}