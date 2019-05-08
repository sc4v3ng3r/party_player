import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:party_player/bloc/BlocInterface.dart';
import 'package:party_player/widgets/ActionButton.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/CircularItemWidget.dart';
import 'package:party_player/widgets/SectionTitle.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import 'widgets/DisplayItem.dart';

class HomeWidget extends StatefulWidget {
  //final HomeWidgetBloc _bloc = HomeWidgetBloc();

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final HomeWidgetBloc _bloc = HomeWidgetBloc();

  static final Widget _leading = Padding(
    child: Image.asset("images/icon.png",),
    padding: EdgeInsets.all(10.0),
  );

  @override
  void initState() {
    super.initState();

    _bloc.initData();
  }


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

            StreamBuilder<List<AlbumInfo>>(
              stream: _bloc.topAlbumsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  if (snapshot.hasError) return Text('${snapshot.error}');
                  else return CircularProgressIndicator();
                }
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
            StreamBuilder<List<ArtistInfo>>(
              stream: _bloc.topArtistsStream,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  if (snapshot.hasError) return Text('${snapshot.error}');
                  else return CircularProgressIndicator();
                }

                return Container(
                  height: 180.0,
                  child: ListView.builder(
                      //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
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
            SectionTitle( title: "GENRES",),
//            Text('Genres available'),

            StreamBuilder<List<GenreInfo>>(
              stream: _bloc.genresStream,
              builder: (context, snapshot){
                if (!snapshot.hasData) {
                  if (snapshot.hasError)
                    return Text('${snapshot.error}');
                  else return CircularProgressIndicator();
                }

                if (snapshot.data.isEmpty)
                  return Center(child: Text('There is no playlist'));

                return Container(
                  height: 180.0,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: .8,
                      crossAxisCount: 2,
                    ),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return Stack(
                          children: <Widget>[
                            DisplayItem(
                              title: snapshot.data[index].name,
                            ),

                            Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: (){},
                                  ),
                                ),
                            ),
                          ],
                        );
                      }
                  ),
                );
              },
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "YOUR PLAYLISTS",),
            StreamBuilder<List<PlaylistInfo>>(
              stream: _bloc.playlistStream,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  if (snapshot.hasError)
                    return Text('${snapshot.error}');
                  else return CircularProgressIndicator();
                }

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
          ],

          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}

class HomeWidgetBloc extends BlocInterface {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final BehaviorSubject< List<AlbumInfo> > _topAlbumsSubject = BehaviorSubject();
  Observable<List<AlbumInfo>> get topAlbumsStream => _topAlbumsSubject.stream;

  final BehaviorSubject<List<ArtistInfo>> _topArtistSubject = BehaviorSubject();
  Observable<List<ArtistInfo>> get topArtistsStream => _topArtistSubject.stream;

  final BehaviorSubject<List<PlaylistInfo>> _playlistSubject = BehaviorSubject();
  Observable< List<PlaylistInfo> > get playlistStream => _playlistSubject.stream;

  final BehaviorSubject<List<GenreInfo>> _genreSubject = BehaviorSubject();
  Observable<List<GenreInfo>> get genresStream => _genreSubject.stream;

  void loadTopArtists({ArtistSortType sortType = ArtistSortType.DEFAULT}) {

//    addArtistToSink(null);

    audioQuery
        .getArtists(sortType: ArtistSortType.MORE_ALBUMS_NUMBER_FIRST)
        .then(addArtistToSink)
        .catchError(addArtistError);
  }

  void initData() async {
    try {
      List<AlbumInfo> topAlbums = await audioQuery.getAlbums(sortType: AlbumSortType.MOST_RECENT_YEAR);
      if (topAlbums != null){
        addAlbumToSink(topAlbums);
        loadTopArtists();
        loadPlaylists(sortType: PlaylistSortType.NEWEST_FIRST);
        loadGenres();
      }
    }

    on PlatformException catch(ex){
      addArtistError(ex.code);
      addAlbumError(ex.code);
      addPlaylistError(ex.code);
    }

  }

  addArtistToSink(final List<ArtistInfo> data) => _topArtistSubject.sink.add(data);
  addArtistError(final Object error) => _topArtistSubject.sink.addError(error);

  loadAlbums({final AlbumSortType sortType = AlbumSortType.DEFAULT}) {

//    addAlbumToSink(null);

    audioQuery
        .getAlbums()
        .then(addAlbumToSink)
        .catchError(addAlbumError);
  }

  addAlbumToSink(final List<AlbumInfo> data) => _topAlbumsSubject.sink.add(data);
  addAlbumError(final Object error) => _topAlbumsSubject.sink.addError(error);


  loadPlaylists( {PlaylistSortType sortType = PlaylistSortType.DEFAULT} ){
//    addPlaylistSink(null);

    audioQuery.getPlaylists()
        .then( addPlaylistSink )
        .catchError( addPlaylistError );
  }

  addPlaylistSink(final List<PlaylistInfo> data) => _playlistSubject.sink.add(data);
  addPlaylistError( final Object error ) => _playlistSubject.sink.addError(error);


  loadGenres() async {
//    addGenreError(null);
    List<GenreInfo> genres = await audioQuery.getGenres();
    genres.forEach( (genre) {

    } );
    audioQuery.getGenres()
        .then( addGenreToSink )
        .catchError( addGenreError );
  }

  addGenreToSink(final List<GenreInfo> data) => _genreSubject.sink.add(data);
  addGenreError( final Object error ) => _genreSubject.sink.addError( error );

  @override
  void dispose() {
    _topArtistSubject?.close();
    _topAlbumsSubject?.close();
    _genreSubject?.close();
    _playlistSubject?.close();
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
