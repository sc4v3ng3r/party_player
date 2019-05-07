import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_player/widgets/ActionButton.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/CircularItemWidget.dart';
import 'package:party_player/widgets/SectionTitle.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  static final Widget _leading = Padding(
    child: Image.asset("images/icon.png",),
    padding: EdgeInsets.all(10.0),
  );

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    final sliverAppBar = SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      elevation: 0.0,
      pinned: false,
      snap: false,
      primary: true,
      title: Text("Home",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0)),
      backgroundColor: Colors.blueGrey[400],
      brightness: Brightness.dark,
      leading: _leading,

      actions: <Widget>[
        IconButton(
            splashColor: Colors.blueGrey[400].withOpacity(0.5),
            icon: Icon(
              Icons.info_outline,
            ),
            onPressed: () {}
        ),
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

    final playingNowArtistTitle = Padding(
      padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
      child: Center(
        child: Text(
          'Artist Name',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 14.0,
              fontFamily: "Quicksand",
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );

    final quickActionsTitle = Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
      child: new Text(
        "QUICK ACTIONS",
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            letterSpacing: 2.0,
            color: Colors.black.withOpacity(0.75)),
      ),
    );

    final quickActionsRow = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ActionButton(
          title: "RECENTS",
          iconData: CupertinoIcons.restart,
          iconColor: Colors.blueGrey[400],
        ),
        ActionButton(
          title: "MOST PLAYED",
          iconData: Icons.assessment,
          iconColor: Colors.blueGrey[400],
        ),
        ActionButton(
          title: "RANDOM",
          iconData: CupertinoIcons.shuffle_thick,
          iconColor: Colors.blueGrey[400],
        ),
      ],
    );

    return CustomScrollView(
      slivers: <Widget>[
        sliverAppBar,
        new SliverList(
          delegate: SliverChildListDelegate(<Widget>[

            playingNowArtistTitle,
            quickActionsTitle,
            quickActionsRow, // quick action ACTIONS
            //Recents artists
            /// TODO quando ainda nao houver recentes, nao mostrar essa widget
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "YOUR RECENTS!", ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.music_note),
                Text('Explore you music'),
              ],
            ), //recentW(),

            //Top Albums
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle(title: "TOP ALBUMS",),

            FutureBuilder<List<AlbumInfo>>(
              future: audioQuery.getAlbums(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.hasError) return Text('${snapshot.error}');
                return Container(
                  height: 200.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: <Widget>[
                            CardItemWidget(
                              width: 160.0,
                              height: 190.0,
                              title: snapshot.data[index].title,
                              subtitle: snapshot.data[index].artist,
                              backgroundImage: snapshot.data[index].albumArt,
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              },
            ), //topAlbums(),

            //Top Artists
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle(title: "TOP ARTISTS",),
            FutureBuilder<List<ArtistInfo>>(
              future: audioQuery.getArtists(
                  sortType: ArtistSortType.MORE_ALBUMS_NUMBER_FIRST),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.hasError) return Text('${snapshot.error}');

                return Container(
                  height: 180.0,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return CircularItemWidget(
                          title: snapshot.data[index].name,
                          tag: snapshot.data[index].id,
                          imagePath: snapshot.data[index].artistArtPath,
                        );
                      }),
                );
              },
            ),
            //topArtists(),

            // favourites
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle(
              title: "YOUR FAVOURITES",
            ),
            Text('FAVOURITES body'), //topArtists(),


            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "YOUR PLAYLISTS",),
            FutureBuilder<List<PlaylistInfo>>(
              future: audioQuery.getPlaylists(
                  sortType: PlaylistSortType.NEWEST_FIRST),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.hasError) return Text('${snapshot.error}');

                if (snapshot.data.isEmpty)
                  return Center(child: Text('There is no playlist'));

                return Container(
                  height: 180.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: <Widget>[
                            CircularItemWidget(
                              title: snapshot.data[index].name,
                              tag: snapshot.data[index].id,
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              },
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "GENRES",),
            Text('Genres available'),
          ]),
        ),
      ],
    );
  }
}

/*


Widget recentW() {
    return new Container(
      height: 215.0,
      child: new ListView.builder(
        itemCount: recents.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
          child: InkWell(
            onTap: () {
              MyQueue.songs = recents;
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new NowPlaying(widget.db, recents, i, 0);
              }));
            },
            child: new Card(
              elevation: 12.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      child: Hero(
                        tag: recents[i].id,
                        child: getImage(recents[i]) != null
                            ? Container(
                          height: 120.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  getImage(recents[i]),
                                ),
                                fit: BoxFit.cover,
                              )),
                        )
                            : new Image.asset(
                          "images/back.jpg",
                          height: 120.0,
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 180.0,
                        child: Padding(
                          // padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                          padding: EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                recents[i].title,
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.70)),
                                maxLines: 1,
                              ),
                              SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  recents[i].artist,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color:
                                      Colors.black.withOpacity(0.75)),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
 */
