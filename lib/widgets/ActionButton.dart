import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Callback = void Function();

class ActionButton extends StatelessWidget {
  final Callback onTap;
  final String title;
  final IconData iconData;
  final Color iconColor;
  final Color titleColor;

  ActionButton({this.onTap, this.title, this.iconData, this.iconColor, this.titleColor = Colors.black});

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RawMaterialButton(
              fillColor: Colors.transparent,
              onPressed: null,
              child: Material(
                color: Colors.transparent,
                elevation: 15.0,
                shape: CircleBorder(),
                child: new Icon(
                  iconData,
                  size: 50.0,
                  color: iconColor,
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
            new Text(
              this.title ?? "",
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12.0, letterSpacing: 2.0),
            ),
          ],
        ),
        Positioned.fill(
          child: InkWell(
            splashColor: Colors.blueGrey[200],
            highlightColor: Colors.blueGrey[200].withOpacity(0.3),
            onTap: () {
              if (onTap != null) onTap();
            },
          ),
        ),
      ],
    );
  }
}
