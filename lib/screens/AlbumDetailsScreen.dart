import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/screenBloc/AlbumDetailsScreenBloc.dart';
import 'package:party_player/widgets/InfoWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:party_player/widgets/SongItem.dart';
import 'package:provider/provider.dart';

class AlbumDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AlbumDetailsScreenBloc bloc = Provider.of<AlbumDetailsScreenBloc>(context);

    final expandedHeight = MediaQuery.of(context).size.width;

    final sliverAppBar = SliverAppBar(
      expandedHeight: expandedHeight,
      forceElevated: false,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(""),
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: bloc.heroTag,
              child: (bloc.currentAlbum.albumArt) != null
                  ? Image.file(
                      File(bloc.currentAlbum.albumArt),
                      fit: BoxFit.cover,
                    )
                  : Image.asset("images/artist.jpg", fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );

    final albumName = Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 10.0),
      child: Text(
        bloc.currentAlbum.title,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: "Quicksand"),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final albumSongsNumber = bloc.albumSongsNumber;

    final infoRow = InfoWidget(
        title: bloc.currentAlbum.artist,
        subtitle: (albumSongsNumber) > 1
            ? "$albumSongsNumber Songs"
            : "$albumSongsNumber Song");

    final infoSliverList = SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                albumName,
                infoRow,
              ],
            ),
          ),
        ),
      ]),
    );

    final songsSliverList = StreamBuilder<List<SongInfo>>(
      stream: bloc.songsStream,
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
            return SongItem(
              songTitle: snapshot.data[index].title,
              songArtist: snapshot.data[index].artist,
              tag: snapshot.data[index].id,
              image: snapshot.data[index].albumArtwork,
              duration: int.parse(snapshot.data[index].duration),
            );
          }, childCount: snapshot.data.length),
        );
      }, // end streamBuilder builder method
    );

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            NotificationListener(
              onNotification: (notification) =>
                  bloc.addNotification(notification),
              child: CustomScrollView(
                controller: bloc.scrollController,
                slivers: <Widget>[
                  sliverAppBar,
                  infoSliverList,
                  songsSliverList,
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
                            CupertinoIcons.shuffle_thick,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
