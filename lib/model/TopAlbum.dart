

class TopAlbum {
  static const ALBUM_ID = "albumId";
  static const SCORE = "score";

  int albumId;
  int score;

  TopAlbum({this.albumId, this.score});

  TopAlbum.fromJson(final Map<String, dynamic> json) :
      albumId = json[ALBUM_ID],
      score = json[SCORE];

  Map<String, dynamic > toJson() => {
    ALBUM_ID : albumId,
    SCORE : score,
  };

}