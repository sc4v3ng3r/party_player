import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final icon = IconButton(
      icon: Icon(
        Icons.music_note,
        color: Colors.white,
        size: 90,
      ),
      iconSize: 90,
    );

    final text = Center(
      child: Text(
        'PartyPlayer',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Quicksand', color: Colors.white, fontSize: 45),
      ),
    );

    final mainColumn = Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        text,
      ],
    );

    return Material(
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: mainColumn,
      ),
    );
  }
}
