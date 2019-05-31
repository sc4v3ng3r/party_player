
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ScrollingBloc.dart';
import 'package:rxdart/rxdart.dart';

class ArtistDetailsScreenBloc extends ScrollingBloc {

  final Object heroTag;
  final ArtistInfo currentArtist;
  final FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  AlbumInfo _currentAlbum;

  // artist albums stream
  final BehaviorSubject< List<AlbumInfo> > _artistAlbumsSubject = BehaviorSubject();
  Observable< List<AlbumInfo> > get albumsStream => _artistAlbumsSubject.stream;

  // album songs stream
  final BehaviorSubject< List<SongInfo> > _artistAlbumSongsSubject = BehaviorSubject();
  Observable< List<SongInfo> > get songsStream => _artistAlbumSongsSubject.stream;

  // album image stream
  final BehaviorSubject<String> _imageSubject = BehaviorSubject();
  Observable<String> get imageStream => _imageSubject.stream;

  List<AlbumInfo> get artistAlbums => _artistAlbumsSubject.stream.value;
  AlbumInfo get currentAlbum => _currentAlbum;
  List<SongInfo> get currentAlbumSongs => _artistAlbumSongsSubject.stream.value;

  ArtistDetailsScreenBloc({@required this.heroTag, @required this.currentArtist});

  initData(){
    _audioQuery.getAlbumsFromArtist(artist: currentArtist)
        .then( (albums){
          albums.forEach( (album)
          {
            if (album.albumArt == currentArtist.artistArtPath){
              print('found');
              loadAlbumSongs(album);
              return;
            }
          });

          _addToAlbumSink(albums);

         }).catchError(( _addAlbumError ));
  }

  loadAlbumSongs(final AlbumInfo album)  {
    _currentAlbum = album;

    _audioQuery
      .getSongsFromArtistAlbum(album: album, artist: currentArtist, sortType: SongSortType.DISPLAY_NAME)
      .then( _addToSongSink )
      .catchError( _addToSongError );

      _imageSubject.sink.add( album.albumArt );
  }

  _addToAlbumSink( final List<AlbumInfo> data ) => _artistAlbumsSubject.sink.add(data);
  _addAlbumError( final Object error ) => _artistAlbumsSubject.sink.addError(error);
  
  _addToSongSink( final List<SongInfo> data ) => _artistAlbumSongsSubject.sink.add(data);
  _addToSongError( final Object error ) => _artistAlbumSongsSubject.sink.addError(error);

  @override
  void dispose() {
    super.dispose();
    _artistAlbumsSubject?.close();
    _artistAlbumSongsSubject?.close();
    _imageSubject?.close();
  }
}