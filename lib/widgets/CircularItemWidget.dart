import 'dart:io';

import 'package:flutter/material.dart';

class CircularItemWidget extends StatelessWidget {
  final String title, imagePath;
  final Object tag;

  CircularItemWidget({@required this.title, @required this.tag, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0, right: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

                Hero(
                  tag: this.tag,
                  child: Material(
                    elevation: 10.0,
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      radius: 65.0,
                      backgroundImage: (imagePath == null) ? AssetImage("images/music.jpg") :
                          FileImage(File(imagePath)),
                    ),
                  ),
                ),

          SizedBox(height: 10.0,),

          SizedBox(
            width: 150.0,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      title.toUpperCase(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.70)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

}
