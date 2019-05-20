import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/BlocInterface.dart';
import 'package:party_player/bloc/PlaybackService.dart';
import 'package:party_player/database/DatabaseProvider.dart';
import 'package:party_player/model/FavoriteSong.dart';
import 'package:party_player/model/RecentSong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:party_player/database/TopSongDAO.dart';
import 'package:party_player/database/TopAlbumDAO.dart';
import 'package:party_player/database/TopArtistDAO.dart';
import 'package:party_player/database/FavoriteSongDAO.dart';
import 'package:party_player/database/RecentSongDAO.dart';

/// Guardar A ultima musica que foi executada no playback
/// Recuperar A ultima musica que foi executada no playback
/// Contabilizar, Armazenar e recuperar cancoes mais tocadas
/// Contabilizar, Armazenar e recuperar Albums mais tocados
/// Contabilizar, Armazenar e recuperar Artistas mais tocados
/// Favoritar e desfavorita uma cancao.
/// Armazenar e Recuperar Cancoes favoritas.
/// Guardar e Recuperar as cancoes mais recentes
/// Servir de interface para o playback

class ApplicationBloc extends BlocInterface {

  final PlaybackService playbackService = PlaybackService();
  
  Database _db;
  Database get database => _db;

  List<String> _recentSongs;
  List<String> _topArtists;
  List<String> _topAlbums;
  Map<String, String> _favoriteSongs;

  List<String> get recentSongIds => _recentSongs;
  List<String> get topArtistIds => _topArtists;
  List<String> get topAlbumIds => _topAlbums;
  List<String> get favoriteSongIds => _favoriteSongs.values.toList();

  Future<bool> initAppData() async {

    bool flag = false;
    _db = await DataBaseProvider.instance.database;

    if (_db != null)
      flag = true;

    _favoriteSongs = await _extractFavouritesSongs();
     playbackService.updateFavoriteSongs( _favoriteSongs );
     playbackService.favouritesSongsStream.listen( (map) => _favoriteSongs = map );
     
     _recentSongs = await _extractRecentSongs();
     playbackService.updateRecentSongs( _recentSongs );
     playbackService.recentSongsIdStream.listen( (recent) => _recentSongs = recent );

     return flag;
  }

  Future< Map<String,String> > _extractFavouritesSongs() async {
    List<FavoriteSong> ids = await FavoriteSongDAO.getFavoriteSongs();

    if(ids.isEmpty)
      return { };
    
    return Map.fromIterable( ids.map( (item) => '${item.songId}', ),
      key: (i) => i.toString(), value:(i) => i.toString()
    );
  }
  
  Future< List<String> > _extractRecentSongs() async {
    List<RecentSong> recentSongs = await RecentSongDAO.getRecentSongs();
    return recentSongs.isEmpty ? [] : recentSongs.map( (r) => '${r.songId}' ).toList();
  }
  
  @override
  void dispose() {
    print( 'Application bloc dispose ');
    playbackService.dispose();
  }

}