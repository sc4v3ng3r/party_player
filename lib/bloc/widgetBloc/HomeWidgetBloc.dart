import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import '../BlocInterface.dart';

class HomeWidgetBloc extends BlocInterface {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final BehaviorSubject< List<AlbumInfo> > _topAlbumsSubject = BehaviorSubject();
  Observable<List<AlbumInfo>> get topAlbumsStream => _topAlbumsSubject.stream;

  final BehaviorSubject<List<ArtistInfo>> _topArtistSubject = BehaviorSubject();
  Observable<List<ArtistInfo>> get topArtistsStream => _topArtistSubject.stream;

  final BehaviorSubject<List<PlaylistInfo>> _playlistSubject = BehaviorSubject();
  Observable< List<PlaylistInfo> > get playlistStream => _playlistSubject.stream;

  final BehaviorSubject<List<GenreInfo>> _genreSubject = BehaviorSubject();
  Observable<List<GenreInfo>> get genresStream => _genreSubject.stream;

  final BehaviorSubject<List<SongInfo>> _recentSubject = BehaviorSubject();
  Observable< List<SongInfo> > get recentSongsStream => _recentSubject.stream;

  final BehaviorSubject<List<SongInfo>> _favouritesSubject = BehaviorSubject();
  Observable<List<SongInfo>> get favouritesSongStream => _favouritesSubject.stream;

  final List<String> recentIds;
  final List<String> topAlbums;
  final List<String> topArtists;
  final List<String> favorites;

  HomeWidgetBloc({
    @required this.recentIds,
    @required this.topAlbums,
    @required this.topArtists,
    @required this.favorites,
  });

  _addPlaylistSink(final List<PlaylistInfo> data) => _playlistSubject.sink.add(data);
  _addPlaylistError( final Object error ) => _playlistSubject.sink.addError(error);

  _addAlbumToSink(final List<AlbumInfo> data) => _topAlbumsSubject.sink.add(data);
  _addAlbumError(final Object error) => _topAlbumsSubject.sink.addError(error);

  _addGenreToSink(final List<GenreInfo> data) => _genreSubject.sink.add(data);
  _addGenreError( final Object error ) => _genreSubject.sink.addError( error );

  _addArtistToSink(final List<ArtistInfo> data) => _topArtistSubject.sink.add(data);
  _addArtistError(final Object error) => _topArtistSubject.sink.addError(error);

  _addRecentSongsToSink( final List<SongInfo> data ) => _recentSubject.sink.add(data);
  _addRecentSongsError( final Object error ) => _recentSubject.sink.addError( error );

  _addFavoriteSongsToSink( final List<SongInfo> data) => _favouritesSubject.sink.add(data);
  _addFavoriteSongsError( final Object error ) => _favouritesSubject.sink.add(error);

  void loadTopArtists({ArtistSortType sortType = ArtistSortType.DEFAULT}) async {
//    List<String> artistIds = await _loadTopArtistIds();
    audioQuery
        .getArtists(sortType: ArtistSortType.MORE_ALBUMS_NUMBER_FIRST)
        .then(_addArtistToSink)
        .catchError(_addArtistError);
  }

  void initData() async {
    try {

      List<SongInfo> recentSongs = await audioQuery.getSongsById(ids: recentIds,
          sortType: SongSortType.CURRENT_IDs_ORDER);

      //List<AlbumInfo> topAlbums = await audioQuery.getAlbums(sortType: AlbumSortType.MOST_RECENT_YEAR);

      if (recentSongs != null){
        _addRecentSongsToSink(recentSongs);
        //_addAlbumToSink(topAlbums);
        loadTopAlbums();
        loadTopArtists();
        loadFavourites();
        loadPlaylists(sortType: PlaylistSortType.NEWEST_FIRST);
        loadGenres();
      }
    }

    on PlatformException catch(ex){
      _addArtistError(ex.code);
      _addAlbumError(ex.code);
      _addPlaylistError(ex.code);
      _addRecentSongsError(ex.code);
    }

  }

  loadFavourites(){
    audioQuery.getSongsById(ids: favorites, sortType: SongSortType.CURRENT_IDs_ORDER)
        .then( _addFavoriteSongsToSink )
        .catchError(_addFavoriteSongsError );

  }
  loadTopAlbums({final AlbumSortType sortType = AlbumSortType.DEFAULT}) {
//
////    addAlbumToSink(null);
//
    audioQuery
        .getAlbums()
        .then(_addAlbumToSink)
        .catchError(_addAlbumError);
  }

  loadPlaylists( {PlaylistSortType sortType = PlaylistSortType.DEFAULT} ){
//    addPlaylistSink(null);

    audioQuery.getPlaylists()
        .then( _addPlaylistSink )
        .catchError( _addPlaylistError );
  }


  loadGenres() async {
//    addGenreError(null);
    List<GenreInfo> genres = await audioQuery.getGenres();
    genres.forEach( (genre) {

    } );
    audioQuery.getGenres()
        .then( _addGenreToSink )
        .catchError( _addGenreError );
  }


  @override
  void dispose() {
    _topArtistSubject?.close();
    _topAlbumsSubject?.close();
    _genreSubject?.close();
    _playlistSubject?.close();
    _recentSubject?.close();
    _favouritesSubject?.close();
  }

}