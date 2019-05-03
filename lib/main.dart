import 'dart:async';
import 'package:flutter/material.dart';
import 'package:party_player/Home.dart';
import 'package:party_player/screens/PlayingNowScreen.dart';
import 'package:party_player/widgets/ArtistGridWidget.dart';
import 'package:party_player/widgets/BottomBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: MainWidget(title: 'Flutter Demo Home Page'),
    );
  }
}


class MainWidget extends StatefulWidget {

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

  final HomePageBloc bloc = HomePageBloc();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              return Home();

            case HomePageNavigation.ARTISTS:
              return ArtistGridWidget();

            case HomePageNavigation.ALBUMS:
              return Center(child: Text('Albums'),);

            case HomePageNavigation.SONGS:
              return Center(child: Text('Songs'),);
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
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context){
                    return PlayingNowScreen(0);
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
    super.dispose();
  }
}

enum HomePageNavigation {HOME, ARTISTS, ALBUMS, SONGS, }

class HomePageBloc {
  final StreamController<HomePageNavigation> _navigationController = StreamController.broadcast();
  Stream get navigationStream => _navigationController.stream;
  
  void setNavigationState(final HomePageNavigation option) => _navigationController.sink.add(option);
  
  void dispose() => _navigationController?.close();
}