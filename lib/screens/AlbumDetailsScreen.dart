import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ScrollingBloc.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:party_player/widgets/SongItem.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AlbumDetailsScreen extends StatelessWidget {
  static const _songsNumberStyle = const TextStyle(fontSize: 13.0);

  @override
  Widget build(BuildContext context) {
    AlbumDetailsScreenBloc bloc = Provider.of<AlbumDetailsScreenBloc>(context);

    final sliverAppBar = SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
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

    final infoRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
                bloc.currentAlbum.artist,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              (albumSongsNumber) > 1
                  ? Text(
                      "$albumSongsNumber Songs",
                      style: _songsNumberStyle,
                    )
                  : Text(
                      "$albumSongsNumber Song",
                      style: _songsNumberStyle,
                    )
            ],
          ),
        ),
      ],
    );

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
      stream: bloc._songsSubject,
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
        child: NotificationListener(
          onNotification: (notification) => bloc.addNotification(notification),
          child: CustomScrollView(
            slivers: <Widget>[
              sliverAppBar,
              infoSliverList,
              songsSliverList,
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<ScrollDirection>(
        stream: bloc.scrollStream,
        builder: (context, snapshot) {
          if (snapshot.data == ScrollDirection.idle) return _createFAB();

          return Container();
        },
      ),
    );
  }

  Widget _createFAB() => AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(seconds: 1),
        child: FloatingActionButton(
          backgroundColor: Colors.blueGrey[400],
          heroTag: GlobalKey(),
          child: Icon(
            CupertinoIcons.shuffle_thick,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      );
}

class AlbumDetailsScreenBloc extends ScrollingBloc {
  final AlbumInfo currentAlbum;
  final FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  final Object heroTag;
  final BehaviorSubject<List<SongInfo>> _songsSubject = BehaviorSubject();
  Observable get songsStream => _songsSubject.stream;

  AlbumDetailsScreenBloc(
      {@required this.currentAlbum, @required this.heroTag}) {
    print('AlbumDetailsBloc tag: $heroTag');
  }

  int get albumSongsNumber => int.parse(currentAlbum.numberOfSongs);

  loadData() async {
    _audioQuery
        .getSongsFromAlbum(album: currentAlbum)
        .then(_addToSink)
        .catchError(_addError);
  }

  _addToSink(final List<SongInfo> data) => _songsSubject.sink.add(data);
  _addError(final Object error) => _songsSubject.sink.addError(error);

  @override
  void dispose() {
    super.dispose();
    _songsSubject?.close();
  }
}
