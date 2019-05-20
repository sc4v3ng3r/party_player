import 'dart:io';

import 'package:flutter/material.dart';

class RecentSongItem extends StatelessWidget {
  final String title;
  final double width, height;

  RecentSongItem({this.width = 100, this.height = 100,
    @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.black,),
            iconSize: 55,
            onPressed: null,
          ),
          Flexible(
            child: Text(title,
              textAlign: TextAlign.center,
              maxLines: 2, overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );

  }
}
