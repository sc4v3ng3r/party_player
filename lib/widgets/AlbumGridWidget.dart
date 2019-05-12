import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/widgetBloc/AlbumGridWidgetBloc.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:provider/provider.dart';

class AlbumGridWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    AlbumGridWidgetBloc bloc = Provider.of<AlbumGridWidgetBloc>(context);

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
      stream: bloc.albumStream,
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
                  bloc.addNotification(notification),
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
                                  context, bloc, height: 250);
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
                                context, bloc, width: 150, height: 250),
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
                      stream: bloc.scrollStream,
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
  Widget _buildItem(AlbumInfo data, BuildContext context,  AlbumGridWidgetBloc bloc,
      {double width, double height}) {
    return Stack(
      children: <Widget>[
        CardItemWidget(
          heroTag: '${data.title}${data.id}',
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
              onTap: () => bloc.openAlbumDetailsScreen(data, context)
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
}
