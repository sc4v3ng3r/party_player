import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'package:party_player/bloc/PlaybackService.dart';
import 'package:party_player/widgets/ActionButton.dart';
import 'package:provider/provider.dart';
class SongBottomSheet extends StatelessWidget {

  final SongInfo song;

  SongBottomSheet({this.song});

  @override
  Widget build(BuildContext context) {
    PlaybackService playback = Provider.of<ApplicationBloc>(context).playbackService;

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
      children: <Widget>[
        ActionButton(
          iconData: Icons.skip_next,
          title: 'Play next',
          onTap: (){
            playback.addToPlayNext(song);
            Navigator.pop(context);
          },
        ),

        ActionButton(
          iconData: Icons.playlist_add,
          title: 'Add to',
          onTap: (){
            Navigator.pop(context);
          },
        ),

        ActionButton(
          iconData: Icons.add_to_queue,
          title: 'Enqueue',
          onTap: (){
            playback.addToQueue(song);
            Navigator.pop(context);
          },
        )
      ],
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
