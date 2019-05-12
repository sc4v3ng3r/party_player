import 'dart:async';
import 'package:flutter/material.dart';
import 'package:party_player/widgets/HomeWidget.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'package:party_player/screens/PlayingNowScreen.dart';
import 'package:party_player/widgets/AlbumGridWidget.dart';
import 'package:party_player/widgets/ArtistGridWidget.dart';
import 'package:party_player/widgets/BottomBar.dart';
import 'package:party_player/widgets/SongListWidget.dart';
import 'package:provider/provider.dart';

import 'bloc/widgetBloc/AlbumGridWidgetBloc.dart';
import 'bloc/widgetBloc/ArtistGridWidgetBloc.dart';
import 'bloc/widgetBloc/SongListWidgetBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final ApplicationBloc bloc = ApplicationBloc();

  @override
  Widget build(BuildContext context) {
    return Provider<ApplicationBloc>(
      builder: (_) => bloc,
      dispose: (_, value) { print(' o metodo esperado'); },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainWidget(title: "PartyPlayer",),
      ),
    );
  }
}


// TODO: Isso aqui devera ir para outro arquivo

class MainWidget extends StatefulWidget {

  static final floatActionButtonHeroTag = 'BBFT'; // bottom bar FAB tag

  static const TITLES_MAP = {
    HomePageNavigation.HOME : "Home",
    HomePageNavigation.ARTISTS : "Artists",
    HomePageNavigation.ALBUMS : "Albums",
    HomePageNavigation.SONGS : "Songs"
  };

  MainWidget({Key key, this.title}) : super(key: key);
  final String title;

  final List<BottomBarItem> _bottomActions = [
    BottomBarItem(
      iconData: Icons.home,
      text: TITLES_MAP[HomePageNavigation.HOME],
      color: Colors.white,
    ),
    BottomBarItem(
      iconData: Icons.person,
      text: TITLES_MAP[HomePageNavigation.ARTISTS],
      color: Colors.white,
    ),
    BottomBarItem(
      iconData: Icons.album,
      text: TITLES_MAP[HomePageNavigation.ALBUMS],
      color: Colors.white,
    ),
    BottomBarItem(
      iconData: Icons.library_music,
      text: TITLES_MAP[HomePageNavigation.SONGS],
      color: Colors.white,
    ),
  ];

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {

  final NavigationBloc bloc = NavigationBloc();
  ApplicationBloc _appBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBloc ??= Provider.of<ApplicationBloc>(context);
    return Scaffold(

      body: StreamBuilder<HomePageNavigation>(
        initialData: HomePageNavigation.HOME,
        stream: bloc.navigationStream,
        builder: (context, snapshot){

          if (!snapshot.hasData)
            return Center(child: Text('Show some splash screen'),);

          if (snapshot.hasError)
            return Center(child: Text('ERROR BUILDING BODY '),);

          switch(snapshot.data){
            case HomePageNavigation.HOME:
              return HomeWidget();

            case HomePageNavigation.ARTISTS:
              return Provider<ArtistGridWidgetBloc>(
                builder: (_){
                  var bloc = ArtistGridWidgetBloc();
                  bloc.loadArtists();
                  return bloc;
                },
                child: ArtistGridWidget(),
                dispose: (_,bloc) => bloc.dispose(),
              );

            case HomePageNavigation.ALBUMS:

              return Provider<AlbumGridWidgetBloc>(
                builder: (_) {
                  var bloc = AlbumGridWidgetBloc();
                  bloc.loadAlbums();
                  return bloc;
                },
                child: AlbumGridWidget(),
                dispose: (_, bloc ) => bloc.dispose(),
              );

            case HomePageNavigation.SONGS:
              return Provider<SongListWidgetBloc>(
                builder: (_){
                  var bloc = SongListWidgetBloc();
                  bloc.loadSongs();
                  return bloc;
                },
                child: SongListWidget(),
                dispose: (_, bloc) => bloc.dispose(),
              );
          }
        }
      ),

      bottomNavigationBar: BottomBar(
        height: 50,
        backgroundColor: Colors.blueGrey[400],
        actions: widget._bottomActions,
        onTabSelected: (index) => bloc.setNavigationState( HomePageNavigation.values[index] ),
      ),

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_circle_filled, size: 30.0,),
          backgroundColor: Colors.blueGrey[400],
          elevation: 2.0,
          heroTag: MainWidget.floatActionButtonHeroTag,
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context){
                    return Provider<ApplicationBloc>(
                      builder: (_) => _appBloc,
                        child: PlayingNowScreen(0),
                        dispose: (context, value) { print("Provider for PlayingNow Screen dipose call"); },
                    );
                  }
              )
            );
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  @override
  void dispose() {
    bloc?.dispose();
    print("MainWidget dispose");
    super.dispose();
  }
}

enum HomePageNavigation {HOME, ARTISTS, ALBUMS, SONGS, }

class NavigationBloc {
  final StreamController<HomePageNavigation> _navigationController = StreamController.broadcast();
  Stream get navigationStream => _navigationController.stream;

  void setNavigationState(final HomePageNavigation option) => _navigationController.sink.add(option);
  
  void dispose() => _navigationController?.close();
}

//
//class SplashScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.grey.withOpacity(0.7),
//      child: Directionality(
//        textDirection: TextDirection.ltr,
//        child: Stack(
//          children: <Widget>[
//            Positioned.fill(
//                child: Column(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(
//                        child: CircularProgressIndicator(),
//                      ),
//                    ],
//                ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
