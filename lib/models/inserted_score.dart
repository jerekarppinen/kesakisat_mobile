class InsertedScore {
  int sportId;
  int numberOfScores;
  int numberOfPlayers;

  InsertedScore({this.numberOfScores, this.numberOfPlayers, this.sportId });

  InsertedScore.fromMap(Map<String, dynamic> map) {
    numberOfScores = map["number_of_scores"];
    numberOfPlayers = map["number_of_players"];
    sportId = map["sport_id"];
  }
}