import 'package:party_player/database/DatabaseProvider.dart';
import 'package:party_player/model/TopSong.dart';
import 'package:sqflite/sqflite.dart';

class TopSongDAO {

  static insertTopSong(final TopSong topSong) async {
    var db = await DataBaseProvider.instance.database;
    db.insert(DataBaseProvider.TABLE_TOP_SONGS, topSong.toJson(), conflictAlgorithm: ConflictAlgorithm.replace )
        .then( (id) => print('TopSongDAO insert success $id'))
        .catchError( (error) => print('TopSongDAO delete error $error') );
  }

  static updateTopSong( final TopSong song ) async {
    var db = await DataBaseProvider.instance.database;
    db.update(DataBaseProvider.TABLE_TOP_SONGS,  song.toJson())
        .then( (id) => print('TopSongDAO update success $id'))
        .catchError( (error) => print('TopSongDAO update error $error') );
  }

  static deleteTopSong(final TopSong topSong) async {
    var db = await DataBaseProvider.instance.database;
    db.delete(DataBaseProvider.TABLE_TOP_SONGS,
        where: '${TopSong.SONG_ID} =?',
        whereArgs: [topSong.songId]
    ).then( (id) => print('TopSongDAO insert success $id'))
        .catchError( (error) => print('TopSongDAO delete error $error') );
  }

  static Future<List<TopSong>> getTopSongs() async {
    var db = await DataBaseProvider.instance.database;
    var mapList = await db.query(DataBaseProvider.TABLE_TOP_SONGS, orderBy: '${TopSong.SCORE} DESC');
    
    return mapList.isNotEmpty ? mapList.map( (json) => TopSong.fromJson(json) ).toList()
        : [];
  }
  
  static clearData() async {
    var db = await DataBaseProvider.instance.database;
    db.rawDelete('DELETE FROM ${DataBaseProvider.TABLE_TOP_SONGS}')
        .then( (id) => print('TopSongDAO clear success $id'))
        .catchError( (error) => print('TopSongDAO clear error $error') );

  }

}