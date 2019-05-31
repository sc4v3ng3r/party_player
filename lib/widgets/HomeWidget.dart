import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'package:party_player/bloc/widgetBloc/HomeWidgetBloc.dart';
import 'package:party_player/screens/AlbumDetailsScreen.dart';
import 'package:party_player/widgets/ActionButton.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/CircularItemWidget.dart';
import 'package:party_player/widgets/SectionTitle.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:party_player/bloc/screenBloc/AlbumDetailsScreenBloc.dart';


class HomeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final Orientation orientation = MediaQuery.of(context).orientation;
    var playbackService = Provider.of<ApplicationBloc>(context).playbackService;
    var bloc = Provider.of<HomeWidgetBloc>(context);

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
      leading:  Padding(
        child: Image.asset("images/icon.png",),
        padding: EdgeInsets.all(10.0),
      ),

      actions: <Widget>[
        IconButton(
            splashColor: Colors.blueGrey[400].withOpacity(0.5),
            icon: Icon(
              Icons.info_outline,
            ),
            onPressed: () {}
        ),

        IconButton(
            splashColor: Colors.blueGrey[400].withOpacity(0.5),
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {}
        ),
      ],

      flexibleSpace: new FlexibleSpaceBar(
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[

            StreamBuilder<SongInfo>(
              initialData: playbackService.currentSong,
              stream: playbackService.songReadyStream,
              builder: (context, snapshot){
                if ( (snapshot.hasData) && (snapshot.data?.albumArtwork != null))
                  return Image.file(File(snapshot.data.albumArtwork), fit: BoxFit.fitWidth,);

                return Image.asset(
                    "images/music.jpg",
                    fit: BoxFit.fitWidth,
                  );
              },
            ),
          ],
        ),
      ),
    );

    final playingNowArtistTitle = Padding(
      padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
      child: Center(
        child: StreamBuilder<SongInfo>(
          initialData: playbackService.currentSong,
          stream: playbackService.songReadyStream,
          builder: (context, snapshot){
            return Text(

              (snapshot.data == null) ? 'PartyPlayer' :'${snapshot.data.artist} - ${snapshot.data.title}' ,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 14.0,
                  fontFamily: "Quicksand",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            );
          },
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
          onTap: () {
            playbackService.playNewQueue( List.from(bloc.recentSongs) );
          },
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

    final recentSongsWidget = Container(
      height: 180,
      child: StreamBuilder<List<SongInfo>>(
        stream: bloc.recentSongsStream,
        builder: (context, snapshot){
          if (!snapshot.hasData){
            if (snapshot.hasError) return Text('${snapshot.error}');
            else return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.isEmpty)
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.music_note),
                Text('Explore you music'),
              ],
            );

          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return CardItemWidget(
                  width: 160.0,
                  height: 160.0,
                  heroTag: snapshot.data[index].id,
                  title: snapshot.data[index].title,
                  subtitle: snapshot.data[index].artist,
                  backgroundImage: snapshot.data[index].albumArtwork,
                  elevation: 4.0,
                  stripeColor: Colors.white.withOpacity(0.5),
                );
              },
          );
        },
      ),
    );

    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        sliverAppBar,
        new SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[

            playingNowArtistTitle,
            quickActionsTitle,
            quickActionsRow, // quick action ACTIONS

            //Recents artists
            /// TODO quando ainda nao houver recentes, nao mostrar essa widget
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "YOUR RECENTS!", ),
            recentSongsWidget,

             //recentW(),

            //Top Albums
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle(title: "TOP ALBUMS",),

            StreamBuilder<List<AlbumInfo>>(
              stream: bloc.topAlbumsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  if (snapshot.hasError) return Text('${snapshot.error}');

                  else return Center(child: CircularProgressIndicator());
                }

                return Container(
                  height: 200.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {

                        var title = snapshot.data[index].title;
                        var heroTag = snapshot.data[index].id + title;
                        return Stack(
                          children: <Widget>[

                            CardItemWidget(
                              width: 160.0,
                              height: 190.0,
                              heroTag: heroTag,
                              title: title,
                              subtitle: snapshot.data[index].artist,
                              backgroundImage: snapshot.data[index].albumArt,
                            ),

                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print('Album clicked: ${snapshot.data[index].id}');
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context){
                                          //TODO: vai para o bloc
                                          return Provider<AlbumDetailsScreenBloc>(
                                            builder: (_) {
                                              var bloc = AlbumDetailsScreenBloc(
                                                currentAlbum: snapshot.data[index],
                                                heroTag: heroTag,
                                              );
                                              bloc.loadData();
                                              return bloc;
                                            } ,
                                            dispose: (context, bloc) => bloc.dispose(),
                                            child: AlbumDetailsScreen(),
                                          );
                                        })
                                    );
                                  },
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
              stream: bloc.topArtistsStream,
              builder: (context, artistSnapshot) {

                if (!artistSnapshot.hasData) {
                  if (artistSnapshot.hasError)
                    return Text('${artistSnapshot.error}');
                  else return Center(child: CircularProgressIndicator());
                }

                return Container(
                  height: 200.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: artistSnapshot.data.length,
                      itemBuilder: (context, index) {
                        return CircularItemWidget(
                          title: artistSnapshot.data[index].name,
                          tag: '${artistSnapshot.data[index].name}${artistSnapshot.data[index].id}',
                          imagePath: artistSnapshot.data[index].artistArtPath,
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

            StreamBuilder< List<SongInfo> >(
              stream: bloc.favouritesSongStream,
              builder: (context, snapshot){
                if (!snapshot.hasData){
                  if (snapshot.hasError)
                    return Center(child: Text('${snapshot.error}'),);
                  return Center(child: CircularProgressIndicator(),);
                }

                if (snapshot.data.isEmpty)
                  return Text('FAVOURITES body');

                return Container(
                  height: 180,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: .0),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return CardItemWidget(
                          width: 160.0,
                          height: 160.0,
                          heroTag: GlobalKey(),
                          elevation: 4.0,
                          backgroundImage: snapshot.data[index].albumArtwork,
                          title: snapshot.data[index].title,
                          stripeColor: Colors.white.withOpacity(.5),

                        );
                      }
                  ),
                );
              },
            ),


//            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
//            SectionTitle( title: "GENRES",),
////            Text('Genres available'),
//
//            StreamBuilder<List<GenreInfo>>(
//              stream: _bloc.genresStream,
//              builder: (context, snapshot){
//                if (!snapshot.hasData) {
//                  if (snapshot.hasError)
//                    return Text('${snapshot.error}');
//                  else return CircularProgressIndicator();
//                }
//
//                if (snapshot.data.isEmpty)
//                  return Center(child: Text('There is no genres'));
//
//                return Container(
//                  height: 180.0,
//                  child: GridView.builder(
//                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                      mainAxisSpacing: 4.0,
//                      crossAxisSpacing: 8.0,
//                      childAspectRatio: .8,
//                      crossAxisCount: 2,
//                    ),
//                      shrinkWrap: true,
//                      scrollDirection: Axis.horizontal,
//                      itemCount: snapshot.data.length,
//                      itemBuilder: (context, index){
//                        return Stack(
//                          children: <Widget>[
//                            DisplayItem(
//                              title: snapshot.data[index].name,
//                            ),
//
//                            Positioned.fill(
//                                child: Material(
//                                  color: Colors.transparent,
//                                  child: InkWell(
//                                    onTap: (){},
//                                  ),
//                                ),
//                            ),
//                          ],
//                        );
//                      }
//                  ),
//                );
//              },
//            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            SectionTitle( title: "YOUR PLAYLISTS",),
            StreamBuilder<List<PlaylistInfo>>(
              stream: bloc.playlistStream,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  if (snapshot.hasError)
                    return Text('${snapshot.error}');
                  else return CircularProgressIndicator();
                }

                if (snapshot.data.isEmpty)
                  return Center(child: Text('There is no playlist'));

                return Container(
                  height: 200.0,
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
