import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';

class ArtistGridWidget extends StatefulWidget {
  @override
  _ArtistGridWidgetState createState() => _ArtistGridWidgetState();
}

class _ArtistGridWidgetState extends State<ArtistGridWidget> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {

//    return SafeArea(
//      child: Column(
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
//          AppBar(
//            title: Text('Artistas',
//              style: TextStyle(
//                  fontSize: 32.0,
//                  color: Colors.blueGrey,
//                  fontFamily: "Quicksand",
//                  fontWeight: FontWeight.w600,
//                  letterSpacing: 1.0
//              ),
//            ),
//
//            elevation: .0,
//            backgroundColor: Colors.transparent,
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.search, color: Colors.blueGrey[400],),
//                onPressed: (){},
//              ),
//            ],
//          ),
//
//          Flexible(
//            child: FutureBuilder<List<ArtistInfo>>(
//          future: audioQuery.getArtists(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData)
//              return Column(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Center(
//                    child: CircularProgressIndicator(),
//                  ),
//                ],
//              );
//
//            if (snapshot.hasError) return Text('${snapshot.error}');
//
//            if (snapshot.data.isEmpty)
//              return NoDataWidget(title: "There is no artists");
//            return GridView.builder(
//                itemCount: snapshot.data.length,
//                gridDelegate:
//                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//                itemBuilder: (context, index) {
//                  return CardItemWidget(
//                    title: snapshot.data[index].name,
//                    backgroundImage: snapshot.data[index].artistArtPath,
//                    height: 250.0,
//                  );
//                });
//          },
//        ),
//          ),
//        ],
//      ),
//    );
    final sliverAppBar = SliverAppBar(
      floating: false,
      elevation: 0.0,
      pinned: false,
      primary: true,
      title: Text("Artists",
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 32.0,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0)),
      backgroundColor: Colors.white30,
      brightness: Brightness.dark,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, color: Colors.blueGrey,),
            onPressed: () {
              print('search clicked');
              // showSearch(context: context, delegate: SearchSong());
            }),
        IconButton(
          icon: Icon(Icons.sort, color: Colors.blueGrey,),
          onPressed: (){},
        ),
      ],

    );

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          sliverAppBar,
        ];
      },

      body: FutureBuilder<List<ArtistInfo>>(
        future: audioQuery.getArtists(),
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
          return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return CardItemWidget(
                  title: snapshot.data[index].name,
                  backgroundImage: snapshot.data[index].artistArtPath,
                  height: 250.0,
                  elevation: 8.0,
                );
              });
        },
      ),
    );
  }
}
