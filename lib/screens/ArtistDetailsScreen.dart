import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'package:party_player/bloc/PlaybackService.dart';
import 'package:party_player/bloc/screenBloc/ArtistDetailsScreenBloc.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/InfoWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:party_player/widgets/SongItem.dart';
import 'package:party_player/widgets/bottomsheet/SongBottomSheet.dart';
import 'package:provider/provider.dart';

class ArtistDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    ArtistDetailsScreenBloc bloc = Provider.of<ArtistDetailsScreenBloc>(context);
    PlaybackService playback = Provider.of<ApplicationBloc>(context).playbackService;

    var size = MediaQuery.of(context).size;
    final expandedHeight = size.width - 150;

    final sliverAppBar = SliverAppBar(
      expandedHeight: expandedHeight,
      forceElevated: false,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: bloc.heroTag,
              child: StreamBuilder<String>(
                stream: bloc.imageStream,
                initialData: bloc.currentArtist.artistArtPath,
                builder: (context, snapshot){
                  if (!snapshot.hasData)
                    return Image.asset("images/artist.jpg",
                        width: size.width,
                        height: expandedHeight,
                        fit: BoxFit.cover,
                    );
                  return Image.file(
                      File(snapshot.data),
                      height: expandedHeight,
                      width: size.width,
                      fit: BoxFit.cover
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );

    final artistName = Text(
        bloc.currentArtist.name,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: "Quicksand"),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
    );

    final infoRow = StreamBuilder<List<AlbumInfo>>(
      stream: bloc.albumsStream,
      builder: (context, snapshot){
        if (!snapshot.hasData)
          return Container();

        var songsNumber = 0;
        snapshot.data.forEach( (a) => songsNumber+= int.parse( a.numberOfSongs ));

        return Container(
          child: InfoWidget(
            title: (snapshot.data.length > 1) ?
            '${snapshot.data.length} Albums' :
            '${snapshot.data.length} Album',
            subtitle: '$songsNumber Songs',
            icon: Icon(Icons.album, size: 40,),
          ),
        );
      }
    );

    final actionsRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.shuffle),
                onPressed: (){}
            ),

            IconButton(
              icon: Icon(Icons.add_to_queue),
              onPressed: (){},
            ),
          ],
    );

    final topRow = Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          artistName,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              infoRow,
              actionsRow,
            ],
          ),
        ],
      ),
    );

    final artistAlbumList = StreamBuilder<List<AlbumInfo>>(
      stream: bloc.albumsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }, childCount: 1));
        }

        if (snapshot.hasError)
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: Text("Please show error widget!"),
                );
              }, childCount: 1));

        if (snapshot.data.isEmpty)
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return NoDataWidget(
                title: 'There is no Songs',
              );
            }, childCount: 1),
          );

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {

            return Container(
              height: 150.0,
              child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, listViewIndex){
                      var title = snapshot.data[listViewIndex].title;
                      var heroTag = snapshot.data[listViewIndex].id + title;

                      return Stack(
                        children: <Widget>[
                          CardItemWidget(
                            width: 150.0,
                            heroTag: heroTag,
                            title: title,
                            subtitle: '${snapshot.data[listViewIndex].numberOfSongs} Songs',
                            backgroundImage: snapshot.data[listViewIndex].albumArt,
                          ),

                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                onTap: (){
                                  bloc.loadAlbumSongs( snapshot.data[listViewIndex] );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                ),
            );
          }, childCount: 1),
        );
      }, // end streamBuilder builder method
    );

    final artistAlbumSongsList = StreamBuilder< List<SongInfo> >(
      stream: bloc.songsStream,
      builder: (context, snapshot){
      if (!snapshot.hasData) {
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }, childCount: 1));
      }

      if (snapshot.hasError)
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Center(
                child: Text("Please show error widget!"),
              );
            }, childCount: 1));

      if (snapshot.data.isEmpty)
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return NoDataWidget(
              title: 'There is no Songs',
            );
          }, childCount: 1),
        );

        return SliverList(delegate: SliverChildBuilderDelegate(
                (context, sliverIndex){
                  return SongItem(
                    tag: snapshot.data[sliverIndex].id,
                    songTitle: snapshot.data[sliverIndex].title,
                    songArtist: snapshot.data[sliverIndex].artist,
                    image: snapshot.data[sliverIndex].albumArtwork,
                    duration: int.parse(snapshot.data[sliverIndex].duration),
                    onTap: () => playback.playNewQueue( bloc.currentAlbumSongs, start: sliverIndex),
                    optionPress: () => _showBottomSheet(context, bloc, playback, snapshot.data[sliverIndex]),
                  );
            }, childCount: snapshot.data.length
        ));
      },
    );


    return Scaffold(

      body: Container(
        child: Stack(
          children: <Widget>[
            NotificationListener(
              onNotification: (notification) {
                bloc.addNotification(notification);
              },
              child: CustomScrollView(
                controller: bloc.scrollController,
                slivers: <Widget>[
                  sliverAppBar,
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      topRow,
                    ]),
                  ),
                  artistAlbumList,
                  artistAlbumSongsList,
                ],
              ),
            ),

            StreamBuilder<double>(
                stream: bloc.scrollingOffsetStream,
                builder: (context, snapshot) {
                  final defaultTopMargin = expandedHeight - 4.0;
                  //pixels from top where scaling should start
                  final double scaleStart = 96.0;
                  //pixels from top where scaling should end
                  final double scaleEnd = scaleStart * 0.5;

                  double top = defaultTopMargin;
                  double scale = 1.0;

                  if (snapshot.hasData) {
                    top -= snapshot.data; // data is offset
                    if (snapshot.data < defaultTopMargin - scaleStart) {
                      //offset small => don't scale down
                      scale = 1.0;
                    } else if (snapshot.data < defaultTopMargin - scaleEnd) {
                      //offset between scaleStart and scaleEnd => scale down
                      scale = (defaultTopMargin - scaleEnd - snapshot.data) /
                          scaleEnd;
                    } else {
                      //offset passed scaleEnd => hide fab
                      scale = 0.0;
                    }
                  }

                  return Positioned(
                    top: top,
                    right: 16.0,
                    child: Transform(
                      transform: Matrix4.identity()..scale(scale),
                      child: FloatingActionButton(
                          backgroundColor: Colors.blueGrey[400],
                          heroTag: GlobalKey(),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            playback.playNewQueue( bloc.currentAlbumSongs );
                          }),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
  
  _showBottomSheet(BuildContext context, ArtistDetailsScreenBloc bloc, 
      PlaybackService service, SongInfo song){
    showModalBottomSheet(
        context: context, 
        builder: (context) => SongBottomSheet( song: song,),
    );

  }

}

