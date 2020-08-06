class Player {
  int id;
  String name;

  Player({this.id, this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name']
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> event = <String, dynamic>{
      'id': this.id,
      'name': this.name
    };
    return event;
  }
}