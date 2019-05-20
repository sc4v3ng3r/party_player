import 'dart:core';

class TopSong{

  /// Column name SongId
  static const SONG_ID = "songId";

  /// Column name score
  static const SCORE = "score";

  /// song id
  int songId;

  /// score for this song
  int score;

  TopSong({this.songId, this.score});

  TopSong.fromJson( final Map<String, dynamic> json ) :
      songId = json[SONG_ID],
      score = json[SCORE];

  Map<String, dynamic> toJson() => {
    SONG_ID : songId,
    SCORE : score
  };

}