import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/database/DatabaseProvider.dart';
import 'package:party_player/model/FavoriteSong.dart';

class FavoriteSongDAO {

  static addToFavorite( final SongInfo song ) async {
    var db = await DataBaseProvider.instance.database;
    print("is open ${db.isOpen}");

    db.insert(DataBaseProvider.TABLE_FAVOURITES, {FavoriteSong.SONG_ID : song.id}
    ).then( (value){ print('added to favourites ${song.id} operation id: $value');} )
      .catchError( (error) => print('error on add to favourites $error') );
  }

  static removeFromFavourites( final SongInfo song ) async {
    var db = await DataBaseProvider.instance.database;
    print("is open ${db.isOpen}");

    db.delete(DataBaseProvider.TABLE_FAVOURITES,
      where: "${FavoriteSong.SONG_ID} = ?", whereArgs: [song.id])
        .then( (value){ print('removed from favourites ${song.id} operation id: $value'); } )
        .catchError( (error) => print('error on removing from favourites $error') );
  }

  static Future< List<FavoriteSong> > getFavoriteSongs() async {
    var db = await DataBaseProvider.instance.database;
    var data = await db.query(DataBaseProvider.TABLE_FAVOURITES);

    List<FavoriteSong> ids =  data.isNotEmpty ? data.map( (map) =>  FavoriteSong.fromJson(map) ).toList() : [];
    return ids;
  }

  static clearData() async {
    var db = await DataBaseProvider.instance.database;

    db.rawDelete('DELETE FROM ${DataBaseProvider.TABLE_FAVOURITES}')
        .then( (id) => print('FavoriteSongDAO clear success $id'))
        .catchError( (error) => print('FavoriteSongDAO clear error $error') );
  }

}