import 'package:party_player/database/DatabaseProvider.dart';
import 'package:party_player/model/TopArtist.dart';
import 'package:sqflite/sqflite.dart';

class TopArtistDAO {

  static insertTopArtist(final TopArtist topArtist) async {
    var db = await DataBaseProvider.instance.database;
    db.insert(DataBaseProvider.TABLE_TOP_ARTISTS, topArtist.toJson(), conflictAlgorithm: ConflictAlgorithm.replace )
        .then( (id) => print('TopArtistDAO insert success $id'))
        .catchError( (error) => print('TopArtistDAO insert error $error') );
  }

  static updateTopArtist(final TopArtist topArtist) async {
    var db = await DataBaseProvider.instance.database;
    db.update(DataBaseProvider.TABLE_TOP_ARTISTS, topArtist.toJson())
        .then( (id) => print('TopArtistDAO update success $id'))
        .catchError( (error) => print('TopArtistDAO update error $error') );
  }

  static deleteTopArtist(final TopArtist topArtist) async {
    var db = await DataBaseProvider.instance.database;
    db.delete(DataBaseProvider.TABLE_TOP_ARTISTS, where: "${TopArtist.ARTIST_ID} =?",
        whereArgs: [topArtist.artistId])
        .then( (id) => print('TopArtistDAO delete success $id'))
        .catchError( (error) => print('TopArtistDAO delete error $error') );
  }

  static Future<List<TopArtist>> getTopArtists() async {
    var db = await DataBaseProvider.instance.database;
    var mapList = await db.query(DataBaseProvider.TABLE_TOP_ARTISTS,
      orderBy: '${TopArtist.SCORE} DESC'
    );

    return mapList.isNotEmpty ? mapList.map( (json) => TopArtist.fromJson(json) ).toList( ) : [];
  }

  static clearData() async {
    var db = await DataBaseProvider.instance.database;
    db.rawDelete('DELETE FROM ${DataBaseProvider.TABLE_TOP_ARTISTS}')
        .then( (id) => print('TopArtistDAO clear success $id'))
        .catchError( (error) => print('TopArtistDAO clear error $error') );

  }
}