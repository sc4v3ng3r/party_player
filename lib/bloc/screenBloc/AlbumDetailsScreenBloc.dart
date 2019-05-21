import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ScrollingBloc.dart';
import 'package:rxdart/rxdart.dart';

class AlbumDetailsScreenBloc extends ScrollingBloc {
  final AlbumInfo currentAlbum;
  List<SongInfo> currentAlbumSongs;

  final FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  final Object heroTag;

  final BehaviorSubject<List<SongInfo>> _songsSubject = BehaviorSubject();
  Observable<List<SongInfo>> get songsStream => _songsSubject.stream;

  final BehaviorSubject<Color> _colorSubject = BehaviorSubject();
  Observable<Color> get colorStream => _colorSubject.stream;

  AlbumDetailsScreenBloc(
      {@required this.currentAlbum, @required this.heroTag});

  int get albumSongsNumber => int.parse(currentAlbum.numberOfSongs);

  loadData() async {
    _audioQuery
        .getSongsFromAlbum(album: currentAlbum, sortType: SongSortType.DISPLAY_NAME)
        .then(_addToSink)
        .catchError(_addError);
  }

  _addToSink(final List<SongInfo> data) {
    _songsSubject.sink.add(data);
    currentAlbumSongs = data;
  }

  _addError(final Object error) => _songsSubject.sink.addError(error);

  @override
  void dispose() {
    super.dispose();
    _songsSubject?.close();
    _colorSubject?.close();
  }
}
