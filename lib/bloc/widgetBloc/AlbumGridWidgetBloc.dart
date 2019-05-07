import 'package:flutter_audio_query/flutter_audio_query.dart';
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
      addToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getAlbums(sortType: _currentSortType)
        .then(addToSink)
        .catchError(addError);
  }

  addToSink(final List<AlbumInfo> data) => _albumSubject.sink.add(data);
  addError(final Object error) => _albumSubject.sink.addError(error);

  @override
  void dispose() {
    _albumSubject?.close();
    super.dispose();
  }
}
