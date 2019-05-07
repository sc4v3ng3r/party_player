import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ScrollingBloc.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:party_player/widgets/SongItem.dart';
import 'package:rxdart/rxdart.dart';

class SongListWidget extends StatefulWidget {
  final SongListWidgetBloc _bloc = SongListWidgetBloc();

  @override
  _SongListWidgetState createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  @override
  void initState() {
    widget._bloc.loadSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final sliverAppBar = SliverAppBar(
      expandedHeight: 50,
      floating: true,
      elevation: 0.0,
      pinned: false,
      snap: true,

      title: Text("Songs",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0)),
      backgroundColor: Colors.blueGrey[400],
      brightness: Brightness.dark,
      //leading: _leading,

      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('search clicked');
        }),

        IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              print('search clicked');
            }),
      ],

      flexibleSpace: new FlexibleSpaceBar(
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image.asset(
              "images/music.jpg",
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );


    return StreamBuilder<List<SongInfo>>(
      stream: widget._bloc.songStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (snapshot.hasError)
          return Center(
            child: Text('${snapshot.error}'),
          );

        if (snapshot.data.isEmpty)
          return Center(
            child: NoDataWidget(
              title: 'There is no songs',
            ),
          );

        return Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (notification) =>
                  widget._bloc.addNotification(notification),
              child: CustomScrollView(
                slivers: <Widget>[
                  sliverAppBar,
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index >= snapshot.data.length)
                        return Container(
                          height: 55.0,
                          color: Colors.transparent,
                        );

                      return SongItem(
                        tag: snapshot.data[index].id,
                        songTitle: snapshot.data[index].title,
                        songArtist: snapshot.data[index].artist,
                        image: snapshot.data[index].albumArtwork,
                        duration: int.parse(snapshot.data[index].duration),
                      );
                    }, childCount: snapshot.data.length+1),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.0, right: 8.0),
                child: Align(
                  child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: .0, right: 8.0),
                      child: StreamBuilder<ScrollDirection>(
                          stream: widget._bloc.scrollStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == ScrollDirection.idle)
                              return _createFAB();

                            return Container();
                          })),
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        );
      },
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

  @override
  void dispose() {
    widget._bloc.dispose();
    super.dispose();
  }
}

class SongListWidgetBloc extends ScrollingBloc {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  BehaviorSubject<List<SongInfo>> _songStreamController = BehaviorSubject();
  Observable<List<SongInfo>> get songStream => _songStreamController.stream;

  SongSortType _currentSortType = SongSortType.DEFAULT;
  SongSortType get currentOrder => _currentSortType;

  void loadSongs({SongSortType sortType = SongSortType.DEFAULT}) {
    if (sortType != _currentSortType) {
      addToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getSongs(sortType: _currentSortType)
        .then(addToSink)
        .catchError(addError);
  }

  addToSink(final List<SongInfo> data) => _songStreamController.sink.add(data);
  addError(final Object error) => _songStreamController.sink.addError(error);

  @override
  void dispose() {
    _songStreamController?.close();
    super.dispose();
  }
}
