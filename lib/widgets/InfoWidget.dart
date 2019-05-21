import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final String title, subtitle;
  final Icon icon;
  static const _subtitleStyle = const TextStyle(fontSize: 13.0);

  InfoWidget({@required this.title, @required this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon ??
              Icon(
                Icons.person,
                size: 40.0,
              ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: _subtitleStyle,
                )
              ],
            ),
          ),
        ],
      );
}
