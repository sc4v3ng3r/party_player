
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/widgets/bottomsheet/SongBottomSheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '../ScrollingBloc.dart';

class SongListWidgetBloc extends ScrollingBloc {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  BehaviorSubject<List<SongInfo>> _songStreamController = BehaviorSubject();
  Observable<List<SongInfo>> get songStream => _songStreamController.stream;

  SongSortType _currentSortType = SongSortType.DEFAULT;
  SongSortType get currentOrder => _currentSortType;

  void loadSongs({SongSortType sortType = SongSortType.DEFAULT}) {
    if (sortType != _currentSortType) {
      addToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getSongs(sortType: _currentSortType)
        .then(addToSink)
        .catchError(addError);
  }

  addToSink(final List<SongInfo> data) => _songStreamController.sink.add(data);
  addError(final Object error) => _songStreamController.sink.addError(error);


  showSongBottomSheet(BuildContext context, SongInfo song){
    showModalBottomSheet(
      context: context,
      builder: (context) => SongBottomSheet(song),
    );
  }

  @override
  void dispose() {
    _songStreamController?.close();
    super.dispose();
  }

}
