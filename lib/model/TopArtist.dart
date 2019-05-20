
class TopArtist{
  static const ARTIST_ID = "artistId";
  static const SCORE = "score";

  int artistId;
  int score;

  TopArtist({this.artistId, this.score});
  
  TopArtist.fromJson( final Map<String, dynamic> json) :
        artistId = json[ARTIST_ID],
        score = json[SCORE];

  Map<String, dynamic> toJson() => {
    ARTIST_ID : artistId,
    SCORE : score
  };
}