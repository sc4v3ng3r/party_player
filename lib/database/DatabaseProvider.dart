import 'dart:io';
import 'package:party_player/model/FavoriteSong.dart';
import 'package:party_player/model/PlaybackState.dart';
import 'package:party_player/model/TopSong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'CurrentQueueColumns.dart';
import 'package:party_player/model/RecentSong.dart';
import 'package:party_player/model/TopAlbum.dart';
import 'package:party_player/model/TopArtist.dart';

class DataBaseProvider {

  static final DataBaseProvider instance = DataBaseProvider._();
  static Database _database;
  static const String _DBNAME = "PartyPlayer.db";
  static const int _VERSION = 1;

  static const TABLE_PLAYBACK_STATE = "PlaybackState";
  static const TABLE_FAVOURITES = "Favourites";
  static const TABLE_RECENTS = "Recents";
  static const TABLE_CURRENT_QUEUE = "CurrentQueue";
  static const TABLE_TOP_ALBUMS = "TopAlbums";
  static const TABLE_TOP_ARTISTS = "TopArtists";
  static const TABLE_TOP_SONGS = "TopSongs";

  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await _initDB();
    return database;
  }

  DataBaseProvider._();

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = p.join(dir.path, _DBNAME);

    return await openDatabase(
      path, version: _VERSION,
      onOpen: (db){
        print(' DB opened ${db.path}');
        //deleteDatabase(path);
      },
      onCreate: _onCreateDb,
    );
  }

  static _onCreateDb(Database db, int version) async {

    /// PLAYBACK_STATE TABLE
    String sql = "CREATE TABLE $TABLE_PLAYBACK_STATE ("
        "${PlaybackState.STATE} INTEGER,"
        "${PlaybackState.RANDOM} BIT,"
        "${PlaybackState.REPEAT} BIT,"
        "${PlaybackState.SEEK_POSITION} INTEGER,"
        "${PlaybackState.CURRENT_SONG_ID} INTEGER,"
        "${PlaybackState.QUEUE_POSITION} INTEGER);";

    await db.execute(sql);

    sql = " CREATE TABLE $TABLE_FAVOURITES (${FavoriteSong.SONG_ID} INTEGER PRIMARY KEY)";
    await db.execute(sql);

    sql = " CREATE TABLE $TABLE_RECENTS ("
        "${RecentSong.SONG_ID} INTEGER PRIMARY KEY,"
        "${RecentSong.TIME} INTEGER);";
    await db.execute(sql);

    /// Current song Queue.
    sql = " CREATE TABLE $TABLE_CURRENT_QUEUE ("
        "${CurrentQueueColumns.POSITION} INTEGER PRIMARY KEY,"
        "${CurrentQueueColumns.SONG_ID} INTEGER);";
    await db.execute(sql);

    sql = " CREATE TABLE $TABLE_TOP_ALBUMS ("
        "${TopAlbum.ALBUM_ID} INTEGER PRIMARY KEY,"
        "${TopAlbum.SCORE} INTEGER);";
    await db.execute(sql);

    sql = " CREATE TABLE $TABLE_TOP_ARTISTS ("
        "${TopArtist.ARTIST_ID} INTEGER PRIMARY KEY,"
        "${TopArtist.SCORE} INTEGER);";
    await db.execute(sql);

    sql = " CREATE TABLE $TABLE_TOP_SONGS ("
        "${TopSong.SONG_ID} INTEGER PRIMARY KEY,"
        "${TopSong.SCORE} INTEGER);";
    await db.execute(sql);

    print('DB created');

  }

}