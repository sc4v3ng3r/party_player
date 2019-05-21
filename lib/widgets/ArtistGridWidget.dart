import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/widgetBloc/ArtistGridWidgetBloc.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:provider/provider.dart';

class ArtistGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    ArtistGridWidgetBloc bloc = Provider.of<ArtistGridWidgetBloc>(context);
    final sliverAppBar = SliverAppBar(
      expandedHeight: 50,
      floating: true,
      elevation: 0.0,
      pinned: false,
      snap: true,
      title: Text("Artists",
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

    return StreamBuilder<List<ArtistInfo>>(
      stream: bloc.artistStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );

        if (snapshot.hasError) return Text('${snapshot.error}');

        if (snapshot.data.isEmpty)
          return NoDataWidget(title: "There is no artists");

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
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 2.0,
                                  crossAxisCount: 2),
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
                            crossAxisSpacing: 4.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildItem(snapshot.data[index],
                                context, bloc, width: 150, height: 250),
                            childCount: snapshot.data.length,
                          )),
                ],
              ),
            ),
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

  Widget _buildItem(ArtistInfo data, BuildContext context, ArtistGridWidgetBloc bloc, {double width, double height}) {
    var heroTag = '${data.name}${data.id}';
    return Stack(
      children: <Widget>[
        CardItemWidget(
          heroTag: heroTag,
          title: data.name,
          backgroundImage: data.artistArtPath,
          width: width,
          height: height,
          elevation: 8.0,
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () => bloc.openArtistDetailScreenBloc(context: context,
                  artist: data, heroTag: heroTag)
            ),
          ),
        ),
      ],
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
