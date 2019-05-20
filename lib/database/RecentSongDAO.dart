
import 'package:sqflite/sqflite.dart';

import 'DatabaseProvider.dart';
import 'package:party_player/model/RecentSong.dart';

class RecentSongDAO{

  static Future<void> insertRecentSong( final RecentSong song ) async {
    var db = await DataBaseProvider.instance.database;
    db.insert( DataBaseProvider.TABLE_RECENTS , song.toJson(),conflictAlgorithm: ConflictAlgorithm.replace )
        .then( (id) => print('RecentSongsDAO insert success $id'))
        .catchError( (error) => print('RecentSongsDAO insert error $error') );
  }

  static Future <void> updateRecentSong( final RecentSong song ) async {
    var db = await DataBaseProvider.instance.database;

    db.update(DataBaseProvider.TABLE_RECENTS, song.toJson())
        .then( (id) => print('RecentSongsDAO update success $id'))
        .catchError( (error) => print('RecentSongsDAO update error $error') );

  }

  static deleteRecentSong(  final RecentSong song ) async {
    var db = await DataBaseProvider.instance.database;
    db.delete(DataBaseProvider.TABLE_RECENTS,
        where: '${RecentSong.SONG_ID} =?',
      whereArgs: [song.songId]
    ).then( (id) => print('RecentSongsDAO delete success $id'))
        .catchError( (error) => print('RecentSongsDAO delete error $error') );
  }

  static Future<List<RecentSong>> getRecentSongs() async {
    var db = await DataBaseProvider.instance.database;
    var mapList = await db.query(DataBaseProvider.TABLE_RECENTS,
        orderBy: '${RecentSong.TIME} DESC');

    return mapList.isNotEmpty ? mapList.map( (json) => RecentSong.fromJson(json) ).toList() : [];
  }


  static clearData() async {
    var db = await DataBaseProvider.instance.database;
    db.rawDelete('DELETE FROM ${DataBaseProvider.TABLE_RECENTS}')
        .then( (id) => print('RecentSongDAO clear success $id'))
        .catchError( (error) => print('RecentSongDAO clear error $error') );

  }

}