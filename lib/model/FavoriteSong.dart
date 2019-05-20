class FavoriteSong {

  /// Column name SongId
  static const SONG_ID = "songId";

  /// Current song id.
  int songId;

  FavoriteSong(this.songId);

  FavoriteSong.fromJson(final Map<String, dynamic> json) :
      songId = json[SONG_ID];

  Map<String, dynamic> toJson() => { SONG_ID : songId };

}