import 'dart:io';
import 'package:flutter/material.dart';

class CardItemWidget extends StatelessWidget {
  final double width, height, elevation;
  final String backgroundImage, title, subtitle;
  static const titleMaxLines = 2;
  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0);

  static final borderValue = Radius.circular(6.0);

  CardItemWidget(
      {this.width,
      this.height,
      this.backgroundImage,
      this.title = "Title",
      this.elevation = 4.0,
      this.subtitle = "subtitle"});

  @override
  Widget build(BuildContext context) {
    final mainContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(6.0),
        image: DecorationImage(
          image: (backgroundImage == null)
              ? AssetImage("images/music.jpg")
              : FileImage(File(backgroundImage)),
          fit: BoxFit.cover,
          alignment: AlignmentDirectional.center,
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0xff, 0xff, 0xff, 0.5),
              borderRadius: BorderRadius.only(bottomLeft: borderValue, bottomRight: borderValue)
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                    child: Text(
                  title,
                  maxLines: titleMaxLines,
                  style: titleTextStyle,
                )),
                Flexible(child: Text(subtitle)),
              ],
            ),
          ),
        ],
      ),
    );

    return Card(
      color: Colors.transparent,
      elevation: elevation,
      child: mainContainer,
    );
  }
}
