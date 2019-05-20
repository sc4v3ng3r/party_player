

class PlaybackState {
  
  /// last playback state
  static const STATE = "state";

  /// randomly mode state
  static const RANDOM = "random";

  /// repeat mode state
  static const REPEAT = "repeat";

  /// position in ms of the last song in playback
  static const SEEK_POSITION = "seekPosition";

  /// current song id in playback
  static const CURRENT_SONG_ID = "currentSongId";

  /// current queue position
  static const QUEUE_POSITION = "queuePosition";

  /// PlaybackState index value
  int state;

  /// Playback position in (ms)
  int seekPosition;

  /// Current Song ID
  int currentSong;

  /// Current queue position;
  int queuePosition;

  /// Randomly mode status
  bool isRandom;

  /// Repeat mode status
  bool isRepeat;

  PlaybackState({this.state, this.seekPosition, this.currentSong,
      this.queuePosition, this.isRandom, this.isRepeat});

  PlaybackState.fromJson( final Map<String, dynamic> json) :
        state = json[STATE], 
        seekPosition = json[SEEK_POSITION],
        currentSong = json[CURRENT_SONG_ID],
        queuePosition = json[QUEUE_POSITION],
        isRandom = json[RANDOM],
        isRepeat = json[REPEAT];

  Map<String, dynamic> toJson() => {
    STATE : state,
    SEEK_POSITION : seekPosition,
    CURRENT_SONG_ID : currentSong,
    QUEUE_POSITION : queuePosition,
    RANDOM : isRandom,
    REPEAT : isRepeat,
  };

}