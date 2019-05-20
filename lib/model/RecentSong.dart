class RecentSong {

  static const SONG_ID = "songId";
  static const TIME = "time";

  int songId;
  int time;

  RecentSong({this.songId, this.time});

  RecentSong.fromJson( final Map<String, dynamic> json) :
      songId = json[SONG_ID],
      time = json[TIME];

  Map<String, dynamic> toJson() => {
    SONG_ID : songId,
    TIME : time,
  };

}
