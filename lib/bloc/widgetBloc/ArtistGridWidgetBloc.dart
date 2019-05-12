import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/screenBloc/ArtistDetailsScreenBloc.dart';
import 'package:party_player/screens/ArtistDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../ScrollingBloc.dart';

class ArtistGridWidgetBloc extends ScrollingBloc {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  BehaviorSubject<List<ArtistInfo>> _artistSubject = BehaviorSubject();
  Observable<List<ArtistInfo>> get artistStream => _artistSubject.stream;

  ArtistSortType _currentSortType = ArtistSortType.DEFAULT;
  ArtistSortType get currentSortType => _currentSortType;

  void loadArtists({ArtistSortType sortType = ArtistSortType.DEFAULT}) {
    if (sortType != _currentSortType) {
      addArtistToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getArtists(sortType: _currentSortType)
        .then(addArtistToSink)
        .catchError(addArtistError);
  }

  addArtistToSink(final List<ArtistInfo> data) => _artistSubject.sink.add(data);
  addArtistError(final Object error) => _artistSubject.sink.addError(error);


  openArtistDetailScreenBloc({@required BuildContext context,
    @required ArtistInfo artist, @required Object heroTag}){

    Navigator.push(context,
        MaterialPageRoute(builder:
            (context){
          return Provider<ArtistDetailsScreenBloc>(
            builder: (_){
              var bloc = ArtistDetailsScreenBloc(
                heroTag: heroTag,
                currentArtist: artist,
              );
              bloc.initData();
              return bloc;
            },
            child: ArtistDetailsScreen(),
            dispose: (_, bloc) => bloc.dispose(),
          );
        }),
    );
  }

  @override
  void dispose() {
    _artistSubject?.close();
    super.dispose();
  }
}