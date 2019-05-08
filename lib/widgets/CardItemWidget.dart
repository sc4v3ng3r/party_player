import 'dart:io';
import 'package:flutter/material.dart';

class CardItemWidget extends StatelessWidget {
  final double width, height, elevation;
  final String backgroundImage, title, subtitle;
  final Object heroTag;

  static const titleMaxLines = 2;
  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0);

  static final borderValue = Radius.circular(6.0);

  CardItemWidget(
      {this.width,
      this.height,
      @required this.heroTag,
      this.backgroundImage,
      this.title='',
      this.elevation = 4.0,
      this.subtitle});

  @override
  Widget build(BuildContext context) {


    final mainContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.0),
      ),

      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: (backgroundImage) != null
                ? Image.file(
              File(backgroundImage), height: height, width: width,
              fit: BoxFit.cover,
            )
                : Image.asset("images/artist.jpg", fit: BoxFit.cover, height: height, width: width),
          ),

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
                  textAlign: (subtitle == null) ? TextAlign.center : TextAlign.left,
                  style: titleTextStyle,
                )),
                (subtitle != null) ? Flexible(child: Text(subtitle)) : Container(width: .0,height: .0,),
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
