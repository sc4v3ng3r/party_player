import 'dart:io';

import 'package:flutter/material.dart';

class SongItem extends StatelessWidget {

  final String image, songTitle, songArtist;
  final int duration;
  final Object tag;
  static final imageSize = 55.0;
  
  SongItem({this.image, @required this.songTitle, @required this.songArtist,
    @required this.duration, @required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Hero(tag: tag,
          child: (image != null) ? Image.file(File(image), width: imageSize,height: imageSize,) :
          Image.asset("images/artist.jpg"),
      ),

      title: new Text(songTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(color: Colors.black,fontSize: 16.0,)),

      subtitle: new Text(
        songArtist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(fontSize: 12.0, color: Colors.grey),
      ),

      trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black,),
          onPressed: (){ print('more pressed');
          }
      ),

//      trailing: new Text( Duration(milliseconds: duration)
//              .toString()
//              .split('.')
//              .first.substring(3,7),
//          style: new TextStyle(
//              fontSize: 12.0, color: Colors.black54)),

      onTap: () {
//        MyQueue.songs = songs;
//        Navigator.of(context).push(new MaterialPageRoute(
//            builder: (context) => new NowPlaying(widget.db, MyQueue.songs, i, 0)));
//
      },
    );
  }
}
