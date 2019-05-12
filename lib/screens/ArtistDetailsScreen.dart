import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/screenBloc/ArtistDetailsScreenBloc.dart';
import 'package:party_player/widgets/CardItemWidget.dart';
import 'package:party_player/widgets/InfoWidget.dart';
import 'package:party_player/widgets/NoDataWidget.dart';
import 'package:party_player/widgets/SongItem.dart';
import 'package:provider/provider.dart';

class ArtistDetailsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    ArtistDetailsScreenBloc bloc = Provider.of<ArtistDetailsScreenBloc>(context);

    final sliverAppBar = SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width - 150,
      forceElevated: false,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(bloc.currentArtist.name),
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: bloc.heroTag,
              child: StreamBuilder<String>(
                stream: bloc.imageStream,
                initialData: bloc.currentArtist.artistArtPath,
                builder: (context, snapshot){
                  if (!snapshot.hasData)
                    return Image.asset("images/artist.jpg", fit: BoxFit.cover);

                  return Image.file(
                      File(snapshot.data), fit: BoxFit.cover,);
                }
              ),
            ),
          ],
        ),
      ),
    );

    final spacer = Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 10.0),
    );

    final infoRow = StreamBuilder<List<AlbumInfo>>(
      stream: bloc.albumsStream,
      builder: (context, snapshot){
        if (!snapshot.hasData)
          return Container();


        var songsNumber = 0;
        snapshot.data.forEach( (a) => songsNumber+= int.parse( a.numberOfSongs ));

        return Container(
          child: InfoWidget(
            title: (snapshot.data.length > 1) ?
            '${snapshot.data.length} Albums' :
            '${snapshot.data.length} Album',
            subtitle: '$songsNumber Songs',
            icon: Icon(Icons.album, size: 40,),
          ),
        );
      }
    );

    final artistAlbumList = StreamBuilder<List<AlbumInfo>>(
      stream: bloc.albumsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }, childCount: 1));
        }

        if (snapshot.hasError)
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: Text("Please show error widget!"),
                );
              }, childCount: 1));

        if (snapshot.data.isEmpty)
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return NoDataWidget(
                title: 'There is no Songs',
              );
            }, childCount: 1),
          );

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {

            return Container(
              height: 170.0,
              child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, listViewIndex){
                      var title = snapshot.data[listViewIndex].title;
                      var heroTag = snapshot.data[listViewIndex].id + title;
                      return Stack(
                        children: <Widget>[
                          CardItemWidget(
                            width: 170.0,
                            heroTag: heroTag,
                            title: title,
                            subtitle: '${snapshot.data[listViewIndex].numberOfSongs} Songs',
                            backgroundImage: snapshot.data[listViewIndex].albumArt,
                          ),

                          Positioned.fill(child:
                            Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                onTap: (){
                                  bloc.loadAlbumSongs(  snapshot.data[listViewIndex]);
                                },
                              ),
                            ),
                          ),
                        ],

                      );
                    }
                ),
            );
          }, childCount: 1),
        );
      }, // end streamBuilder builder method
    );

    final artistAlbumSongsList = StreamBuilder< List<SongInfo> >(
      stream: bloc.songsStream,
      builder: (context, snapshot){
      if (!snapshot.hasData) {
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }, childCount: 1));
      }

      if (snapshot.hasError)
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Center(
                child: Text("Please show error widget!"),
              );
            }, childCount: 1));

      if (snapshot.data.isEmpty)
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return NoDataWidget(
              title: 'There is no Songs',
            );
          }, childCount: 1),
        );

        return SliverList(delegate: SliverChildBuilderDelegate(
                (context, sliverIndex){
                  return SongItem(
                    tag: snapshot.data[sliverIndex].id,
                    songTitle: snapshot.data[sliverIndex].title,
                    songArtist: snapshot.data[sliverIndex].artist,
                    image: snapshot.data[sliverIndex].albumArtwork,
                    duration: int.parse(snapshot.data[sliverIndex].duration),
                  );
            }, childCount: snapshot.data.length
        ));
      },
    );

    return Scaffold(
      body: CustomScrollView(
            slivers: <Widget>[
              sliverAppBar,
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  spacer,
                  infoRow
                ]),
              ),
              artistAlbumList,
              artistAlbumSongsList,
            ],
      ),
    );
  }

}

