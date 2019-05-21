import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongBottomSheet extends StatelessWidget {

  final SongInfo song;
  final List<Widget> actions;
  SongBottomSheet({this.song, this.actions});

  @override
  Widget build(BuildContext context) {

    final titleRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Flexible(
          child: Text(song.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final actionsRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions,
    );

    // TODO: rounded corners is not working in bottom sheet.
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color(0xFF737373),),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            titleRow,
            SizedBox(height: 24.0,),
            actionsRow
          ],
        ),
      ),
    );
  }
}
