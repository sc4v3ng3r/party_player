import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/screenBloc/AlbumDetailsScreenBloc.dart';
import 'package:party_player/screens/AlbumDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../ScrollingBloc.dart';

class AlbumGridWidgetBloc extends ScrollingBloc {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final BehaviorSubject<List<AlbumInfo>> _albumSubject = BehaviorSubject();
  Observable<List<AlbumInfo>> get albumStream => _albumSubject.stream;

  AlbumSortType _currentSortType = AlbumSortType.DEFAULT;
  AlbumSortType get currentSortType => _currentSortType;

  loadAlbums({final AlbumSortType sortType = AlbumSortType.DEFAULT}) {
    if (sortType != _currentSortType) {
      _addToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getAlbums(sortType: _currentSortType)
        .then(_addToSink)
        .catchError(_addError);
  }

  _addToSink(final List<AlbumInfo> data) => _albumSubject.sink.add(data);
  _addError(final Object error) => _albumSubject.sink.addError(error);

  openAlbumDetailsScreen(final AlbumInfo album, BuildContext context){

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context){
        return Provider<AlbumDetailsScreenBloc>(
          builder: (_){
            var bloc = AlbumDetailsScreenBloc(currentAlbum: album,
                heroTag: '${album.title}${album.id}');
            bloc.loadData();
            return bloc;
          },
          child: AlbumDetailsScreen(),
          dispose: (_, bloc) => bloc.dispose(),
        );
      })
    );
  }
  @override
  void dispose() {
    _albumSubject?.close();
    super.dispose();
  }
}
