import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:party_player/bloc/BlocInterface.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:party_player/database/FavoriteSongDAO.dart';
import 'package:party_player/database/RecentSongDAO.dart';
import 'package:party_player/model/RecentSong.dart';
import 'package:rxdart/rxdart.dart';

/// Bloc que fornece a interface com o audio playback
/// Mantem a lista de execucao atual
///  Adiciona e remove items da lista
///  play, pause, seek, next, previous
///
class PlaybackService with BlocInterface {

  final AudioPlayer _audioPlayer = AudioPlayer();

  final BehaviorSubject< List<SongInfo> > _queueSubject = BehaviorSubject();
  Observable< List<SongInfo> > get queueStream => _queueSubject.stream;

  final BehaviorSubject<AudioPlayerState> _playerStateSubject = BehaviorSubject();
  Observable<AudioPlayerState> get playerStateStream => _playerStateSubject.stream;
  
  final BehaviorSubject<Duration> _positionSubject = BehaviorSubject();
  Observable<Duration> get positionStream => _positionSubject.stream;

  final BehaviorSubject<SongInfo> _currentSongSubject = BehaviorSubject();
  Observable<SongInfo> get songReadyStream => _currentSongSubject.stream;

  final BehaviorSubject<bool> _favoriteSubject = BehaviorSubject();
  Observable<bool> get favoriteStream => _favoriteSubject.stream;
  
  final BehaviorSubject<Map<String,String>> _favouritesSongsSubject = BehaviorSubject();
  Observable< Map<String,String> > get favouritesSongsStream => _favouritesSongsSubject.stream;
  
  /// song queue
  List<SongInfo> _queue = [];
  final Random _indexGenerator = Random();

  Map<String,String> _favoriteSongsIds;

  SongInfo _currentSong;
  SongInfo get currentSong => _currentSong;
  int _currentQueuePosition = 0;

  bool repeat = false;
  bool random = false;

  // current player state
  AudioPlayerState _currentState;

  PlaybackService({List<SongInfo> favourites }) {
   _audioPlayer.onAudioPositionChanged.listen( _positionSubject.sink.add );
   _audioPlayer.onPlayerStateChanged.listen( _playerStateListener );
    AudioPlayer.logEnabled = false;
  }
  

  _addToQueueSink( final List<SongInfo> queue ) => _queueSubject.sink.add( queue );
  _addToPositionSink ( final Duration position ) => _positionSubject.sink.add( position );
  _addToStateSink ( final AudioPlayerState state ) => _playerStateSubject.sink.add(state);
  _addToCurrentSongSink( final SongInfo song ) => _currentSongSubject.sink.add(song);
  _addToFavoriteStream (final bool favorite) => _favoriteSubject.sink.add(favorite);

  updateToFavoriteSongs( final Map<String, String> favoritesSongsIds ) {
    print('Loaded ${favoritesSongsIds.values}' );
    _favoriteSongsIds = favoritesSongsIds;
    _favouritesSongsSubject.sink.add(_favoriteSongsIds);
  }
  
  _playerStateListener(AudioPlayerState state){
    print('state change listener $state');
    _currentState = state;

    switch(state){
      case AudioPlayerState.PAUSED:
        break;

      case AudioPlayerState.PLAYING:
        break;
        
      case AudioPlayerState.COMPLETED:

        /// TODO add statistics
        RecentSongDAO.insertRecentSong(
            RecentSong(
                songId: int.parse(_currentSong.id),
                time: DateTime.now().millisecondsSinceEpoch
            ));

        if (repeat)
          playAt(_currentQueuePosition);

        else if (random)
          _playRandomly();

        else
          next();
        break;

      case AudioPlayerState.STOPPED:

        break;
    }
    _addToStateSink(state);
  }

  void addToQueue(final SongInfo song) {

    _queue.add(song);
    _addToQueueSink(_queue);

    if (_queue.length == 1)
      playAt(0);
  }

  addToPlayNext(SongInfo song){
    _queue.insert(_currentQueuePosition+1, song);
    _addToQueueSink(_queue);
  }

  
  bool _isFavoriteSong(final SongInfo song) => _favoriteSongsIds.containsKey(song.id);
  
  setFavorite(SongInfo song, bool status) {
    
    if (status){
      if (! _isFavoriteSong(song)) {
        FavoriteSongDAO.addToFavorite(song);
        _favoriteSongsIds.putIfAbsent( song.id, () => song.id);
        updateToFavoriteSongs(_favoriteSongsIds);
        _addToFavoriteStream(status);
      }
    }
    
    else {
      if ( _isFavoriteSong(song) ){
        FavoriteSongDAO.removeFromFavourites(song);
        _favoriteSongsIds.remove( song.id );
        updateToFavoriteSongs(_favoriteSongsIds);
        _addToFavoriteStream(status);
      }
    }
      
  }

  playPauseResume() {

    switch (_currentState){
      case AudioPlayerState.COMPLETED:
        if (_queue.isNotEmpty)
          _playSong(_queue[0]);
        break;

      case AudioPlayerState.PAUSED:
        _audioPlayer.resume();
        //_audioPlayer.play(_currentSong.filePath, isLocal: true);
        break;

      case AudioPlayerState.PLAYING:
        _pause();
        break;

      case AudioPlayerState.STOPPED:
        print('Verificar lista de execucao atual e prosseguir!');
        //_audioPlayer.play(song.filePath, isLocal: true);
        break;

      default:
        break;
    }
  }

  bool _hasNextSong() => (_currentQueuePosition + 1) <=  (_queue.length-1);

  bool _hasPrevious() => (_currentQueuePosition -1) >= 0;

  _onComplete(){
    print('Completed');
  }

  _pause()  => _audioPlayer.pause();


  stop() => _audioPlayer.stop();

  seek(double position) {
    if (_audioPlayer.state != AudioPlayerState.COMPLETED || _audioPlayer.state != AudioPlayerState.STOPPED)
      _audioPlayer?.seek( Duration(milliseconds: position.toInt() ) );
  }

  playThisSong(SongInfo song) {
    if (_queue.isNotEmpty)
      _queue.clear();

    addToQueue(song);
    _playSong(song);
  }

  playAt(int position) => _playSong( _queue[position] );

  _playSong(final SongInfo song) async {
    if (_currentState != AudioPlayerState.STOPPED )
      await _audioPlayer.stop();


    _audioPlayer.play(song.filePath, isLocal: true).then(
            (status) {
              //print('PLAY STATUS $status');
              _currentSong = song;
              _currentQueuePosition = _queue.indexOf(song);
              _addToCurrentSongSink(song);
              _addToFavoriteStream( _favoriteSongsIds.containsKey(song.id) );

            }).catchError( (error) => print('DEU ERRO $error') );
  }

  _playRandomly() => playAt( _indexGenerator.nextInt( _queue.length ));

  next() async {
    if (repeat){
      playAt(_currentQueuePosition);
      return;
    }

    if (random){
      _playRandomly();
      return;
    }

    if (!_hasNextSong()){
      playAt(0);
      return;
    }
    playAt(_currentQueuePosition+1);
  }

  previous(){
    if (repeat){
      playAt(_currentQueuePosition);
      return;
    }

    if (random){
      _playRandomly();
      return;
    }

    if (_hasPrevious())
      playAt(_currentQueuePosition-1);

    else playAt(_queue.length-1);
  }

  connect() => AudioService.connect();

  disconnect() => AudioService.disconnect();

  @override
  void dispose() {
    _playerStateSubject?.close();
    _positionSubject?.close();
    _queueSubject?.close();
    _currentSongSubject?.close();
    _favoriteSubject?.close();
    _favouritesSongsSubject?.close();
  }
}
