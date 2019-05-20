
import 'package:party_player/database/DatabaseProvider.dart';
import 'package:party_player/model/TopAlbum.dart';
import 'package:sqflite/sqflite.dart';

class TopAlbumDAO {
  
  static insertTopAlbum(final TopAlbum topAlbum) async {
    var db = await DataBaseProvider.instance.database;
    db.insert( DataBaseProvider.TABLE_TOP_ALBUMS, topAlbum.toJson(), conflictAlgorithm: ConflictAlgorithm.replace)
    .then( (id) => print('TopAlbumDAO insert success $id'))
    .catchError( (error) => print('TopAlbumDAO insert error $error') );
  }
  
  static updateTopAlbum(final TopAlbum topAlbum) async {
    var db = await DataBaseProvider.instance.database;
    db.update(DataBaseProvider.TABLE_TOP_ALBUMS, topAlbum.toJson());
  }
  
  static deleteTopAlbum(final TopAlbum album) async {
    var db = await DataBaseProvider.instance.database;
    db.delete(DataBaseProvider.TABLE_TOP_ALBUMS, 
      where: "${TopAlbum.ALBUM_ID} =?", 
      whereArgs: [album.albumId]
    );
  }
  
  static Future< List<TopAlbum> > getTopAlbums()async {
    var db = await DataBaseProvider.instance.database;
    var mapList = await db.query(DataBaseProvider.TABLE_TOP_ALBUMS, orderBy: "${TopAlbum.SCORE} DESC" );
    
    return mapList.isNotEmpty ? mapList.map(  (json) => TopAlbum.fromJson(json)  ).toList() : [];
  }

  static clearData() async {
    var db = await DataBaseProvider.instance.database;
    db.rawDelete('DELETE FROM ${DataBaseProvider.TABLE_TOP_ALBUMS}')
        .then( (id) => print('TopAlbumtDAO clear success $id'))
        .catchError( (error) => print('TopAlbumDAO clear error $error') );

  }
}