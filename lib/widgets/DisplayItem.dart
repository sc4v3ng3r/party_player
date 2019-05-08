import 'dart:ui';
import 'package:flutter/material.dart';

class DisplayItem extends StatelessWidget {

  final String title;
  final Color backgroundColor;
  DisplayItem({@required this.title, this.backgroundColor,});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Center(
              child: RawMaterialButton(
                fillColor: Colors.transparent,
                onPressed: null,
                child: Material(
                  color: Colors.transparent,
                  elevation: 12.0,
                  shape: CircleBorder(),
                  child: new Icon(
                    Icons.music_note,
                    size: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600), maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
