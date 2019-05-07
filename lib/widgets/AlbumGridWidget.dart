import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:party_player/bloc/ScrollingBloc.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class AlbumGridWidget extends StatefulWidget {
  final AlbumGridWidgetBloc _bloc = new AlbumGridWidgetBloc();

  @override
  _AlbumGridWidgetState createState() => _AlbumGridWidgetState();
}

class _AlbumGridWidgetState extends State<AlbumGridWidget> {
  @override
  void initState() {
    widget._bloc.loadAlbums();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    final sliverAppBar = SliverAppBar(
      expandedHeight: 50,
      floating: true,
      elevation: 0.0,
      pinned: false,
      snap: true,

      title: Text("Albums",
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
    );

    return StreamBuilder<List<AlbumInfo>>(
      stream: widget._bloc.albumStream,
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
                  (orientation == Orientation.portrait)
                      ? SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 2.0,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildItem(snapshot.data[index],
                                  height: 250);
                            },
                            childCount: snapshot.data.length,
                          ))
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 2.0,
                                crossAxisSpacing: 4.0,),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildItem(snapshot.data[index],
                                width: 150, height: 250),
                            childCount: snapshot.data.length,
                          )),
                ],
              ),
            ),

            // float action button
            Align(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, right: 8.0),
                  child: StreamBuilder<ScrollDirection>(
                      stream: widget._bloc.scrollStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == ScrollDirection.idle)
                          return _createFAB();
                        return Container();
                      })),
              alignment: Alignment.bottomRight,
            ),
          ],
        );
      },
    );
  }

  /// Method to create gridView items
  Widget _buildItem(AlbumInfo data, {double width, double height}) {
    return Stack(
      children: <Widget>[
        CardItemWidget(
          title: data.title,
          subtitle: data.artist,
          backgroundImage: data.albumArt,
          width: width,
          height: height,
          elevation: 8.0,
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }

  /// Method that returns a float action button
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
    widget._bloc?.dispose();
    super.dispose();
  }
}

class AlbumGridWidgetBloc extends ScrollingBloc {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final BehaviorSubject<List<AlbumInfo>> _albumSubject = BehaviorSubject();
  Observable<List<AlbumInfo>> get albumStream => _albumSubject.stream;

  AlbumSortType _currentSortType = AlbumSortType.DEFAULT;
  AlbumSortType get currentSortType => _currentSortType;

  loadAlbums({final AlbumSortType sortType = AlbumSortType.DEFAULT}) {
    if (sortType != _currentSortType) {
      addToSink(null);
      _currentSortType = sortType;
    }

    audioQuery
        .getAlbums(sortType: _currentSortType)
        .then(addToSink)
        .catchError(addError);
  }

  addToSink(final List<AlbumInfo> data) => _albumSubject.sink.add(data);
  addError(final Object error) => _albumSubject.sink.addError(error);

  @override
  void dispose() {
    _albumSubject?.close();
    super.dispose();
  }
}
