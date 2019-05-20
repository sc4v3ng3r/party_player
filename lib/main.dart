import 'dart:async';
import 'package:flutter/material.dart';
import 'package:party_player/screens/SplashScreen.dart';
import 'package:party_player/widgets/HomeWidget.dart';
import 'package:party_player/screens/PlayingNowScreen.dart';
import 'package:party_player/widgets/AlbumGridWidget.dart';
import 'package:party_player/widgets/ArtistGridWidget.dart';
import 'package:party_player/widgets/BottomBar.dart';
import 'package:party_player/widgets/SongListWidget.dart';
import 'package:provider/provider.dart';
import 'bloc/widgetBloc/AlbumGridWidgetBloc.dart';
import 'bloc/widgetBloc/ArtistGridWidgetBloc.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'bloc/widgetBloc/HomeWidgetBloc.dart';
import 'bloc/widgetBloc/SongListWidgetBloc.dart';

void main() {
  print('My app main');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final ApplicationBloc bloc = ApplicationBloc();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  Future<bool> _appInitialization;

  @override
  void initState() {
    super.initState();
    _appInitialization = widget.bloc.initAppData();
    print('My app initState');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApplicationBloc>(
      builder: (_) => widget.bloc,

      dispose: (_, bloc) { bloc.dispose(); print('app bloc will be disposed');},

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: FutureBuilder<bool>(
            future: _appInitialization,
            builder: (context, snapshot){
              print('App home future builder');
              print('snapData ${snapshot.data}');
              if (snapshot.hasData)
                return MainWidget(title: 'PartyPlayer',);

              return SplashScreen();
            }
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    switch (state) {

      case AppLifecycleState.resumed:
        print('App resumed');
        widget.bloc.playbackService.connect();
        break;
      case AppLifecycleState.paused:
        print('App paused');
        widget.bloc.playbackService.disconnect();
        break;

      case AppLifecycleState.suspending:
        print('app suspending');
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

    return WillPopScope(
      onWillPop: (){ print('do nothing'); },

      child: Scaffold(
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
                return MultiProvider(
                    providers: [
                      Provider<ApplicationBloc>(
                        builder: (_) => _appBloc,
                      ),

                      Provider<HomeWidgetBloc>(
                        builder: (_) {
                          var bloc = HomeWidgetBloc(
                            recentIds: _appBloc.recentSongIds,
                            topAlbums: _appBloc.topAlbumIds,
                            topArtists: _appBloc.topArtistIds,
                            favorites: _appBloc.favoriteSongIds
                          );

                          bloc.initData();
                          return bloc;
                        },
                        dispose: (_, bloc) => bloc.dispose(),
                      ),
                    ],
                  child: HomeWidget(),
                );

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
                return MultiProvider(
                    providers: [
                      Provider<SongListWidgetBloc>(
                        builder: (_){
                          var bloc = SongListWidgetBloc();
                          bloc.loadSongs();
                          return bloc;
                        },
                        dispose: (context, bloc) => bloc.dispose(),
                      ),

                      Provider<ApplicationBloc>(
                        builder: (_) => _appBloc,
                      )
                    ],
                    child: SongListWidget(),
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
      ),
    );
  }
  
  @override
  void dispose() {
    bloc?.dispose();
    print("MainWidget dispose");
    super.dispose();
  }
}

enum HomePageNavigation { HOME, ARTISTS, ALBUMS, SONGS, }

class NavigationBloc {
  final StreamController<HomePageNavigation> _navigationController = StreamController.broadcast();
  Stream get navigationStream => _navigationController.stream;

  void setNavigationState(final HomePageNavigation option) => _navigationController.sink.add(option);
  
  void dispose() => _navigationController?.close();
}
