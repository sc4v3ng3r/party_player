import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
//import 'package:musicplayer/pages/artistcard.dart';
//import 'package:musicplayer/util/artistInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:party_player/widgets/ChangeableButton.dart';
import 'package:party_player/widgets/SwipeablePictureContainer.dart';
import 'package:swipedetector/swipedetector.dart';
//import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
//import 'package:musicplayer/database/database_client.dart';
//import 'package:musicplayer/util/lastplay.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class PlayingNowScreen extends StatefulWidget {
  final int mode;
  //int index;
  PlayingNowScreen(  this.mode );

  @override
  State<StatefulWidget> createState() {
    return new _StateNowPlaying();
  }
}

class _StateNowPlaying extends State<PlayingNowScreen>
    with SingleTickerProviderStateMixin {
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  bool isPlaying = false;
  int isFav = 1;
  int repeatOn = 0;
  Orientation orientation;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  //bool isOpened = true;
  Animation<double> _animateIcon;
  Timer timer;
  
  bool _showArtistImage;

  get durationText => duration != null
      ? duration.toString().split('.').first.substring(3, 7)
      : '';

  get positionText => position != null
      ? position.toString().split('.').first.substring(3, 7)
      : '';

  @override
  void initState() {
    super.initState();
    _showArtistImage = false;
    initAnim();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  initAnim() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blueGrey[400].withOpacity(0.7),
      end: Colors.blueGrey[400].withOpacity(0.9),
    ).animate( CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
  }

  animateForward() {
    _animationController.forward();
  }

  animateReverse() {
    _animationController.reverse();
  }

  void initPlayer() async {
//    if (player == null) {
//      player = MusicFinder();
//      MyQueue.player = player;
//      var pref = await SharedPreferences.getInstance();
//      pref.setBool("played", true);
//    }
//    //  int i= await widget.db.isfav(song);
//    setState(() {
//      if (widget.mode == 0) {
//        player.stop();
//      }
//      updatePage(widget.index);
//      isPlaying = true;
//    });
//    player.setDurationHandler((d) => setState(() {
//      duration = d;
//    }));
//    player.setPositionHandler((p) => setState(() {
//      position = p;
//    }));
//    player.setCompletionHandler(() {
//      onComplete();
//      setState(() {
//        position = duration;
//        if (repeatOn != 1) ++widget.index;
//        song = widget.songs[widget.index];
//      });
//    });
//    player.setErrorHandler((msg) {
//      setState(() {
//        player.stop();
//        duration = new Duration(seconds: 0);
//        position = new Duration(seconds: 0);
//      });
//    });
  }

  void updatePage(int index) {
//    MyQueue.index = index;
//    song = widget.songs[index];
    //song.timestamp = new DateTime.now().millisecondsSinceEpoch;
//    if (song.count == null) {
//      song.count = 0;
//    } else {
//      song.count++;
//    }
//    player.play(song.uri);
    animateReverse();
    setState(() {
      isPlaying = true;
    });
  }

  void playPause() {
//    if (isPlaying) {
//      player.pause();
//      animateForward();
//      setState(() {
//        isPlaying = false;
//        //  song = widget.songs[widget.index];
//      });
//    } else {
//      player.play(song.uri);
//      animateReverse();
//      setState(() {
//        //song = widget.songs[widget.index];
//        isPlaying = true;
//      });
//    }
  }

  Future next() async {
//    player.stop();
//    // int i=await widget.db.isfav(song);
//    setState(() {
//      int i = widget.index + 1;
//      if (repeatOn != 1) ++widget.index;
//
//      if (i >= widget.songs.length) {
//        i = widget.index = 0;
//      }
//
//      updatePage(widget.index);
//    });
  }

  Future prev() async {
//    player.stop();
//    //   int i=await  widget.db.isfav(song);
//    setState(() {
//      int i = --widget.index;
//      if (i < 0) {
//        widget.index = 0;
//        i = widget.index;
//      }
//      updatePage(i);
//    });
  }

  void onComplete() {
    next();
  }

//  dynamic getImage(Song song) {
//    return song == null
//        ? null
//        : new File.fromUri(Uri.parse(song.albumArt));
//  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: scaffoldState,
      body: orientation == Orientation.portrait ? portrait() : landscape(),
      backgroundColor: Colors.transparent,
    );
  }

  /// TODO criar bottom sheet com a lista de cancoes na queue de execucao
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0))),
                  color: Color(0xFFFAFAFA)),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scrollbar(
                child: new ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: 8,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.06,
                      top: 10.0),
                  itemBuilder: (context, i) => new Column(
                    children: <Widget>[

                      ///TODO This represents a list item of a song
                      new ListTile(
                        leading: new CircleAvatar(
                          child: /*getImage(widget.songs[i]) != null
                              ? new Image.file(
                            getImage(widget.songs[i]),
                            height: 120.0,
                            fit: BoxFit.cover,
                          )
                              : new */Text(
                              'Song Title if has no image'.toUpperCase()),
                        ),
                        title: new Text('Song TItle',
                            maxLines: 1,
                            style: new TextStyle(fontSize: 16.0)),
                        subtitle: Row(
                          children: <Widget>[
                            new Text(
                              'Artist of song',
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Text("-"),
                            ),
                            Text(
                                new Duration(
                                    milliseconds: 4000)
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(3, 7),
                                style: new TextStyle(
                                    fontSize: 11.0, color: Colors.black54))
                          ],
                        ),
                        /*
                        // quando a musica eh aq esta tocando, mostra esse trailing
                        trailing: widget.songs[i].id ==
                            MyQueue.songs[MyQueue.index].id
                            ? new Icon(Icons.play_circle_filled,
                            color: Colors.blueGrey[700])
                            : null,*/

                        onTap: () {
//                          setState(() {
//                            MyQueue.index = i;
//                            player.stop();
//                            updatePage(MyQueue.index);
//                            Navigator.pop(context);
//                          });
                        },
                      ),

                    ],
                  ),
                ),
              ));
        });
  }

  void _showArtistDetail() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0))),
                color: Color(0xFFFAFAFA)),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Text('Current song Artist detail'),/*GetArtistDetail(
              artist: song.artist,
              artistSong: song,
              mode: 2,
            ),*/
          );
        });
  }
  
  /// Metodos de criacao de widgets comuns para o layout
  ///
  Widget _backgroundPictureContainer(final double width, final double height) => Container(
    height: height,  //MediaQuery.of(context).size.width,
    width:  width, // 
    color: Colors.white,
    // TODO fazer a logica do non null
    child: Image.asset("images/music.jpg", fit: BoxFit.fill,), );


  Widget _blurEffect({final double width, final double, height,
    final double sigmaX = 10, final double sigmaY = 15}) => BackdropFilter(
    filter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[900].withOpacity(0.5)),
    ),
  );
  
  Widget _spacingContainer({final double width, final double height}) => 
      Container(
        color: Colors.white, 
        height: height, 
        width: width,
    );

  Widget _seekBarRow({final double width, final double statusBarHeight}) => Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(positionText,style: TextStyle(
          fontSize: 13.0,
          color: Color(0xaa373737),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0
      ),),
      Container(
        width: width * 0.85,
        padding: EdgeInsets.only(
          left: statusBarHeight * 0.5,
        ),
        child: Slider(
          min: 0.0,
          activeColor: Colors.blueGrey.shade400.withOpacity(0.5),
          inactiveColor: Colors.blueGrey.shade300.withOpacity(0.3),
          value: position?.inMilliseconds?.toDouble() ?? 0.0,
          onChanged: (value ){},
//             onChanged: (double value) =>
//               player.seek((value / 1000).roundToDouble()),
//               max: song.duration.toDouble() + 1000,
        ),
      ),
    ],
  );


  Widget _labelsGroup() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: new Text(
              'Song title'.toUpperCase(),
              style: new TextStyle(
                  color: Colors.black.withOpacity(0.85),
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.0,
                  height: 1.5,
                  fontFamily: "Quicksand"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          Text(
            "Song Artist\n".toUpperCase(),
            style: new TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 14.0,
                letterSpacing: 1.8,
                height: 1.5,
                fontWeight: FontWeight.w600,
                fontFamily: "Quicksand"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
  );

  Widget _controllersRow() => Row(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

      //TODO Aqui a gente deve verificar se a musica atual eh favorita, se sim,
      // o botao ja comeca "apertado", se nao, "solto"
      Flexible(
        child: ChangeableIconButton(
          initialStatus: ButtonStatus.PRIMARY,
          primaryIcon: Icon(Icons.favorite_border, color: Colors.blueGrey ),
          secondaryIcon: Icon(Icons.favorite, color: Colors.blueGrey),
          size: 30.0,
          onTap: (status){
            // setFav(song);
          },
        ),
      ),

      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),

      Flexible(
        child: IconButton(
          splashColor: Colors.blueGrey[200],
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_previous,
            color: Colors.blueGrey,
            size: 32.0,
          ),
          onPressed: prev,
        ),
      ),

      Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: FloatingActionButton(
          backgroundColor: _animateColor.value,
          child: new AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: _animateIcon),
          onPressed: playPause,
        ),
      ),

      Flexible(child: IconButton(
        splashColor: Colors.blueGrey[200].withOpacity(0.5),
        highlightColor: Colors.transparent,
        icon: new Icon(
          Icons.skip_next,
          color: Colors.blueGrey,
          size: 32.0,
        ),
        onPressed: next,
      ), ),

      Padding( padding: EdgeInsets.symmetric(horizontal: 5.0) ),

      // TODO: verificar se o modo repeat estivado ou nao, para
      //poder definir o estado inicial do botao!
      Flexible(child: ChangeableIconButton(
        tooltip: "Repeat",
        initialStatus: ButtonStatus.SECONDARY,
        primaryIcon: Icon( Icons.repeat, color: Colors.blueGrey),
        secondaryIcon: Icon( Icons.repeat, color: Colors.blueGrey.withOpacity(0.5)),
        size: 30.0,
        onTap: (status){},
      ),
      ),
    ],
  );

  Widget portrait() {
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double cutRadius = 5.0;

    // Container with background artist image with blur effect
    final backgroundPictureContainer = _backgroundPictureContainer( width, width );

    // controls container positioned
    final spacingContainer = _spacingContainer(width: width, height: MediaQuery.of(context).size.height - width);

    //blur effect in background image
    final blurEffect = _blurEffect( width: width, height: width, sigmaX: 10, sigmaY: 15,);

    final queueSongsButton = Container(
      width: width,
      color: Colors.white,
      child: FlatButton(
        onPressed: _showBottomSheet,
        highlightColor: Colors.blueGrey[200].withOpacity(0.1),
        child: Text("UP NEXT",
          style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              letterSpacing: 2.0,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold),
        ),
        splashColor: Colors.blueGrey[200].withOpacity(0.1),
      ),
    );

    final swipeablePicture = SwipeablePictureContainer(
      width: width - 2 * width * 0.06,
      height: width - width * 0.06,
      heroTag: GlobalKey(),
      stickerText: durationText,
      elevation: 20.0,
      cutRadius: cutRadius,
      onSwipeLeft: next,
      onSwipeRight: prev,
      imagePath: null,
    );

    final seekBarRow = _seekBarRow(width:width * 0.85, statusBarHeight:statusBarHeight * 0.5 );

    final labelsGroup = Expanded( child: _labelsGroup() );

    final controllersButtonsRow = _controllersRow();

    return Stack(
      children: <Widget>[
        backgroundPictureContainer,

        Positioned(child: spacingContainer, top: width,),

        blurEffect,

        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only( top: width * 0.06 * 2 ),
            /// TODO Lembrar de mudar a imagem quando a musica mudar. vai ser um StreamBuilder
            child: swipeablePicture,
          ),
        ),

        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: width * 1.11),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                 seekBarRow,
                 labelsGroup,

                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: controllersButtonsRow
                    ),
                  ),
                  queueSongsButton,
                ],
              ),
          ),
        )
      ],
    );
  }

  Widget landscape() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final swipeablePicture = SwipeablePictureContainer(
      width: height - 2 * MediaQuery.of(context).padding.top,
      height: height - 2 * MediaQuery.of(context).padding.top,
      heroTag: GlobalKey(),
      stickerText: durationText,
      elevation: 20.0,
      cutRadius: 6.0,
      onSwipeLeft: next,
      onSwipeRight: prev,
      imagePath: null,
    );

    final seekbarRow = _seekBarRow(width: height *0.85,
        statusBarHeight: statusBarHeight * 0.5);

    //TODO Aqui a gente deve verificar se a musica atual eh favorita, se sim,
    // o botao ja comeca "apertado", se nao, "solto"
    final favouriteButton = Flexible(
      child: ChangeableIconButton(
        initialStatus: ButtonStatus.PRIMARY,
        primaryIcon: Icon(Icons.favorite_border, color: Colors.blueGrey ),
        secondaryIcon: Icon(Icons.favorite, color: Colors.blueGrey),
        size: 40.0,
        onTap: (status){
          // setFav(song);
        },
      ),
    );

    // TODO: verificar se o modo repeat estivado ou nao, para
    //poder definir o estado inicial do botao!
    final repeatButton = Flexible(child: ChangeableIconButton(
      tooltip: "Repeat",
      initialStatus: ButtonStatus.SECONDARY,
      primaryIcon: Icon( Icons.repeat, color: Colors.blueGrey),
      secondaryIcon: Icon( Icons.repeat, color: Colors.blueGrey.withOpacity(0.5)),
      size: 40.0,
      onTap: (status){},),
    );

    final controllers = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Flexible(
          child: IconButton(
            splashColor: Colors.blueGrey[200],
            highlightColor: Colors.transparent,
            icon: new Icon(
              Icons.skip_previous,
              color: Colors.blueGrey,
              size: 32.0,
            ),
            onPressed: prev,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton(
            backgroundColor: _animateColor.value,
            child: new AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animateIcon),
            onPressed: playPause,
          ),
        ),

        Flexible(child: IconButton(
          splashColor: Colors.blueGrey[200].withOpacity(0.5),
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_next,
            color: Colors.blueGrey,
            size: 32.0,
          ),
          onPressed: next,
        ), ),
      ],
    );

    return Container(
      color: Colors.white,
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[

          Align(
            alignment: Alignment.topLeft,
            child: _backgroundPictureContainer( height - height * 0.12, height),
          ),

          Positioned(
            left: height - 2 * MediaQuery.of(context).padding.top,
            child: Padding(
              padding: EdgeInsets.only(left: .0),
              child: _spacingContainer(width: height * 0.12, height: height),
            ),
          ),

          _blurEffect(width: height - height * 0.12, height: height,sigmaX: 10.0, sigmaY: 10.0),

          Positioned(
            left: height - 1.5 * MediaQuery.of(context).padding.top,
            child: Container(
              width: height - height * 0.12,
              height: height,
              //color: Colors.red,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Center( child: _labelsGroup(),),
                    favouriteButton,
                    Container(
                      height: 90,
                      child:controllers,
                    ),
                    repeatButton,
                    seekbarRow,
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).padding.top,
                  top: MediaQuery.of(context).padding.top),
              /// TODO Lembrar de mudar a imagem quando a musica mudar. vai ser um StreamBuilder
              child: swipeablePicture,
            ),
          ),

        ],
      ),
    );
  }

  Future<void> repeat1() async {
    setState(() {
      if (repeatOn == 0) {
        repeatOn = 1;
        //widget.repeat.write(1);
      } else {
        repeatOn = 0;
        // widget.repeat.write(0);
      }
    });
  }

  Future<void> setFav(song) async {
    //int i = await widget.db.favSong(song);
    setState(() {
      if (isFav == 1)
        isFav = 0;
      else
        isFav = 1;
    });
  }
}
