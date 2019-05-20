import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/PlaybackService.dart';
import 'package:provider/provider.dart';
import '../SongItem.dart';

class SongQueueBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var bloc = Provider.of<PlaybackService>(context);

    return Container(

        height: MediaQuery.of(context).size.height * 0.7,

        child: Scrollbar(

          child: StreamBuilder<List<SongInfo>>(
            stream: bloc.queueStream,
            builder: (context, snapshot){
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.06,
                    top: 10.0),

                itemBuilder: (context, index){
                  return SongItem(
                    duration: int.parse(snapshot.data[index].duration),
                    songArtist: snapshot.data[index].artist,
                    songTitle: snapshot.data[index].title,
                    tag: '${snapshot.data[index].id} ${snapshot.data[index].displayName}',
                    image: snapshot.data[index].albumArtwork,
                    onTap: (){
                      bloc.playAt(index);
                      Navigator.pop(context);
                    },
                  );
                },
//                itemBuilder: (context, i) => new Column(
//                  children: <Widget>[
//                    ///TODO This represents a list item of a song
//                    new ListTile(
//                      leading: new CircleAvatar(
//                        child:
//                        /*getImage(widget.songs[i]) != null
//                              ? new Image.file(
//                            getImage(widget.songs[i]),
//                            height: 120.0,
//                            fit: BoxFit.cover,
//                          )
//                              : new */
//                        Text('Song Title if has no image'.toUpperCase()),
//                      ),
//                      title: new Text('Song Title',
//                          maxLines: 1, style: new TextStyle(fontSize: 16.0)),
//                      subtitle: Row(
//                        children: <Widget>[
//                          new Text(
//                            'Artist of song',
//                            maxLines: 1,
//                            style: new TextStyle(
//                                fontSize: 12.0, color: Colors.black54),
//                          ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Text("-"),
//                          ),
//                          Text(
//                              new Duration(milliseconds: 4000)
//                                  .toString()
//                                  .split('.')
//                                  .first
//                                  .substring(3, 7),
//                              style: new TextStyle(
//                                  fontSize: 11.0, color: Colors.black54))
//                        ],
//                      ),
//                      /*
//                        // quando a musica eh aq esta tocando, mostra esse trailing
//                        trailing: widget.songs[i].id ==
//                            MyQueue.songs[MyQueue.index].id
//                            ? new Icon(Icons.play_circle_filled,
//                            color: Colors.blueGrey[700])
//                            : null,*/
//
//                      onTap: () {
////                          setState(() {
////                            MyQueue.index = i;
////                            player.stop();
////                            updatePage(MyQueue.index);
////                            Navigator.pop(context);
////                          });
//                      },
//                    ),
//                  ],
//                ),
              );
            },
          ),
        ));
  }
}
