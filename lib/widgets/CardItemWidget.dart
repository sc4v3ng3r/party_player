import 'dart:io';
import 'package:flutter/material.dart';

class CardItemWidget extends StatelessWidget {
  final double width, height, elevation;
  final String backgroundImage, title, subtitle;
  final Object heroTag;
  final Color stripeColor;
  static const titleMaxLines = 2;
  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0);

  static final borderValue = Radius.circular(6.0);

  CardItemWidget(
      {this.width,
      this.height,
      this.stripeColor = const Color.fromRGBO(0xff, 0xff, 0xff, 0.5),
      @required this.heroTag,
      this.backgroundImage,
      this.title='',
      this.elevation = 4.0,
      this.subtitle});

  @override
  Widget build(BuildContext context) {


    final mainContainer = Stack(
      fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: (backgroundImage) != null
                ? Image.file(
              File(backgroundImage),
              fit: BoxFit.cover,
            ) : Image.asset("images/artist.jpg", fit: BoxFit.cover, ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: stripeColor,
                //borderRadius: BorderRadius.only(bottomLeft: borderValue, bottomRight: borderValue)
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                      child: Text(
                      title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: titleMaxLines,
                    textAlign: (subtitle == null) ? TextAlign.center : TextAlign.left,
                    style: titleTextStyle,
                  )),
                  (subtitle != null) ? Flexible(child: Text(subtitle)) : Container(width: .0,height: .0,),
                ],
              ),
            ),
          ),
        ],
    );

    return Container(
      width: width,
      height: height,
      child: Card(
        color: Colors.transparent,
        elevation: elevation,
        child: mainContainer,
      ),
    );
  }
}
