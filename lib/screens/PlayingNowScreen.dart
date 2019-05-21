import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:party_player/bloc/ApplicationBloc.dart';
import 'package:party_player/bloc/PlaybackService.dart';
import 'package:party_player/main.dart';
import 'package:party_player/utility/Utility.dart';
import 'package:party_player/widgets/ChangeableButton.dart';
import 'package:party_player/widgets/SwipeablePictureContainer.dart';
import 'package:party_player/widgets/bottomsheet/SongQueueBottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class PlayingNowScreen extends StatefulWidget {
  final int mode;
  //int index;
  PlayingNowScreen(this.mode);

  @override
  State<StatefulWidget> createState() {
    return new _StateNowPlaying();
  }
}

class _StateNowPlaying extends State<PlayingNowScreen>
    with SingleTickerProviderStateMixin {
  PlaybackService _playbackBloc;

  Duration duration = Duration(seconds: 0);
//  Duration position = Duration(seconds: 0);
//  bool isPlaying = false;
  int isFav = 1;
  int repeatOn = 0;
  Orientation orientation;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;

  Timer timer;


  @override
  void initState() {
    super.initState();
    initAnim();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playbackBloc = Provider.of<ApplicationBloc>(context).playbackService;
  }

  @override
  void dispose() {
    print('playingnow dispose');
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
    ).animate(CurvedAnimation(
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
//      isPlaying = true;
    });
  }


  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

//    ApplicationBloc myBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      key: scaffoldState,
      body: orientation == Orientation.portrait ? createPortraitLayout() : landscape(),
      backgroundColor: Colors.transparent,
    );
  }

  void _showQueueBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Provider<PlaybackService>(
            builder: (_) => _playbackBloc,
            child: SongQueueBottomSheet(),
          );
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
            child: Text(
                'Current song Artist detail'), /*GetArtistDetail(
              artist: song.artist,
              artistSong: song,
              mode: 2,
            ),*/
          );
        });
  }

  Image _containerImage(String path) {
    return (path == null ) ? Image.asset(
      "images/music.jpg", fit: BoxFit.fill,
    ) : Image.file(File(path), fit: BoxFit.fill);
  }

  /// Metodos de criacao de widgets comuns para o layout
  /// Isso atualiza toda vez q uma nova cancao eh selecionada
  Widget _backgroundPictureContainer(final double width, final double height) =>
      StreamBuilder<SongInfo>(
        stream: _playbackBloc.songReadyStream,
        builder: (context, snapshot){
          return Container(
              height: height, //MediaQuery.of(context).size.width,
              width: width, //
              color: Colors.white,
              child: _containerImage( (snapshot.data == null) ? null : snapshot.data.albumArtwork ),
          );
        },
      );

  Widget _blurEffect(
          {final double width,
          final double,
          height,
          final double sigmaX = 10,
          final double sigmaY = 15}) =>

      BackdropFilter(
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

  Widget _seekBarRow({final double width, final double statusBarHeight}) =>
      StreamBuilder<Duration>(
        stream: _playbackBloc.positionStream,
        builder: (context, snapshot) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Flexible(
                child: Container(
//                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                  (snapshot.data != null) ? Utility.parseToMinutesSeconds(snapshot.data) : '0:00',
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xaa373737),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0),
                  ),
                ),
              ),

              Container(
                width: width * 0.85,
//                padding: EdgeInsets.only(
//                  left: statusBarHeight * 0.5,
//                ),
                child: Slider(
                  min: 0.0,
                  max: (_playbackBloc.currentSong == null)
                      ? 100000 : double.parse(_playbackBloc.currentSong.duration ?? .0) ,

                  activeColor: Colors.blueGrey.shade400,
                  inactiveColor: Colors.blueGrey.shade300.withOpacity(0.3),
                  value: (snapshot.data != null) ? snapshot.data.inMilliseconds.toDouble() ?? .0 : .0,
                  onChanged: (value) {
                    _playbackBloc.seek( value );
                  },
                ),
              ),

              Flexible(
                child: Container(
                  child: ChangeableIconButton(
                    tooltip: "Repeat",
                    initialStatus: ButtonStatus.SECONDARY,
                    primaryIcon: Icon(Icons.repeat, color: Colors.blueGrey),
                    secondaryIcon:
                    Icon(
                        Icons.repeat, color: Colors.blueGrey.withOpacity(0.5)),
                    size: 30.0,
                    onTap: (status) {
                      _playbackBloc.repeat = (status == ButtonStatus.PRIMARY);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );

  Widget _labelsGroup() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            StreamBuilder<SongInfo>(
              initialData: _playbackBloc.currentSong,
              stream: _playbackBloc.songReadyStream,
              builder: (context, snapshot){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    (snapshot.data == null) ? 'Song title'.toUpperCase() : snapshot.data.title.toUpperCase(),
                    style: TextStyle(
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
                );
              }
            ),

            StreamBuilder<SongInfo>(
                initialData: _playbackBloc.currentSong,
                stream: _playbackBloc.songReadyStream,
                builder: (context, snapshot){
                  return Text(
                      (snapshot.data == null) ? "Song Artist\n".toUpperCase() : snapshot.data.artist.toUpperCase(),
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
                  );
                }
            ),
          ],
        ),
      );

  Widget _playPauseButton(Widget child) => FloatingActionButton(
        backgroundColor: _animateColor.value,
        heroTag: MainWidget.floatActionButtonHeroTag,
        child: child,
        onPressed: _playbackBloc.playPauseResume,
      );



  Widget _controllersRow() => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          StreamBuilder<bool>(
            stream: _playbackBloc.favoriteStream,
            initialData: false,
            builder: (context, snapshot){
              IconData iconData;
              if (snapshot.data)
                iconData = Icons.favorite;
              else iconData = Icons.favorite_border;

              return IconButton(
                iconSize: 30,
                icon: Icon(iconData, color: Colors.blueGrey),
                onPressed: (){
                  _playbackBloc.setFavorite(_playbackBloc.currentSong, (!snapshot.data) );
                },
              );
            },
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
              onPressed: _playbackBloc.previous,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: StreamBuilder<AudioPlayerState>(
                stream: _playbackBloc.playerStateStream,
                builder: (context, snapshot) {
                  print('Button builder');
                  if (snapshot.hasData) {
                    if (snapshot.data == AudioPlayerState.PLAYING)
                      return _playPauseButton(AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _animateIcon));
                  }

                  return _playPauseButton(AnimatedIcon(
                      icon: AnimatedIcons.play_pause, progress: _animateIcon));
                }),
          ),

          Flexible(
            child: IconButton(
              splashColor: Colors.blueGrey[200].withOpacity(0.5),
              highlightColor: Colors.transparent,
              icon: new Icon(
                Icons.skip_next,
                color: Colors.blueGrey,
                size: 32.0,
              ),
              onPressed: _playbackBloc.next,
            ),
          ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),

          // TODO: verificar se o modo repeat estivado ou nao, para
          //poder definir o estado inicial do botao!

          StreamBuilder<bool>(
            stream: _playbackBloc.shuffleStream,
            initialData: false,
            builder: (context, snapshot){
              var color = (snapshot.data) ? Colors.blueGrey : Colors.blueGrey.withOpacity(0.5);

              return IconButton(
                iconSize: 30,
                icon: Icon(Icons.shuffle, color: color,),
                onPressed: (){
                  _playbackBloc.setShuffle( !snapshot.data );
                },
              );
            },
          ),
        ],
      );

  Widget createPortraitLayout() {
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double cutRadius = 5.0;

    // Container with background artist image with blur effect
    final backgroundPictureContainer =
        _backgroundPictureContainer(width, width);

    // controls container positioned
    final spacingContainer = _spacingContainer(
        width: width, height: MediaQuery.of(context).size.height - width);

    //blur effect in background image
    final blurEffect = _blurEffect(
      width: width,
      height: width,
      sigmaX: 10,
      sigmaY: 15,
    );

    final queueSongsButton = Container(
      width: width,
      color: Colors.white,
      child: FlatButton(
        onPressed: _showQueueBottomSheet,
        highlightColor: Colors.blueGrey[200].withOpacity(0.1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.queue_music, color: Colors.black.withOpacity(0.8),),
            Text(
              " UP NEXT",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  letterSpacing: 2.0,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        splashColor: Colors.blueGrey[200].withOpacity(0.1),
      ),
    );

    final swipeablePicture = StreamBuilder<SongInfo>(
      stream: _playbackBloc.songReadyStream,
      builder: (context, snapshot){
        return SwipeablePictureContainer(
          width: width - 2 * width * 0.06,
          height: width - width * 0.06,
          heroTag: GlobalKey(),
          stickerText: (snapshot.data == null) ? '0:00' : Utility.parseToMinutesSeconds(
              Duration(milliseconds: int.parse(snapshot.data.duration))),
          elevation: 20.0,
          cutRadius: cutRadius,
          //onSwipeLeft: next,
          //onSwipeRight: prev,
          imagePath: snapshot.data?.albumArtwork,
        );
      },
    );

    final seekBarRow = _seekBarRow(
        width: width * 0.85, statusBarHeight: statusBarHeight * 0.5);

    final labelsGroup = Expanded(child: _labelsGroup());

    final controllersButtonsRow = _controllersRow();

    return Stack(
      children: <Widget>[
        backgroundPictureContainer,
        Positioned(
          child: spacingContainer,
          top: width,
        ),
        blurEffect,
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: width * 0.06 * 2),

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
                      child: controllersButtonsRow),
                ),
                queueSongsButton,
              ],
            ),
          ),
        )
      ],
    );
  }

  // LANDSCAPE LAYOUT
  Widget landscape() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final swipeablePicture = SwipeablePictureContainer(
      width: height - 2 * MediaQuery.of(context).padding.top,
      height: height - 2 * MediaQuery.of(context).padding.top,
      heroTag: GlobalKey(),
      stickerText: '0:00',
      elevation: 20.0,
      cutRadius: 6.0,
      //onSwipeLeft: next,
      //onSwipeRight: prev,
      imagePath: null,
    );

    final seekbarRow = _seekBarRow(
        width: height * 0.85, statusBarHeight: statusBarHeight * 0.5);

    //TODO Aqui a gente deve verificar se a musica atual eh favorita, se sim,
    // o botao ja comeca "apertado", se nao, "solto"
    final favouriteButton = Flexible(
      child: ChangeableIconButton(
        initialStatus: ButtonStatus.PRIMARY,
        primaryIcon: Icon(Icons.favorite_border, color: Colors.blueGrey),
        secondaryIcon: Icon(Icons.favorite, color: Colors.blueGrey),
        size: 40.0,
        onTap: (status) {
          // setFav(song);
        },
      ),
    );

    // TODO: verificar se o modo repeat estivado ou nao, para
    //poder definir o estado inicial do botao!
    final repeatButton = Flexible(
      child: ChangeableIconButton(
        tooltip: "Repeat",
        initialStatus: ButtonStatus.SECONDARY,
        primaryIcon: Icon(Icons.repeat, color: Colors.blueGrey),
        secondaryIcon:
            Icon(Icons.repeat, color: Colors.blueGrey.withOpacity(0.5)),
        size: 40.0,
        onTap: (status) {},
      ),
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
            //onPressed: prev,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton(
            backgroundColor: _animateColor.value,
            heroTag: MainWidget.floatActionButtonHeroTag,
            child: new AnimatedIcon(
                icon: AnimatedIcons.pause_play, progress: _animateIcon),
//            onPressed: playPause,
          ),
        ),
        Flexible(
          child: IconButton(
            splashColor: Colors.blueGrey[200].withOpacity(0.5),
            highlightColor: Colors.transparent,
            icon: new Icon(
              Icons.skip_next,
              color: Colors.blueGrey,
              size: 32.0,
            ),
            //onPressed: next,
          ),
        ),
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
            child: _backgroundPictureContainer(height - height * 0.12, height),
          ),
          Positioned(
            left: height - 2 * MediaQuery.of(context).padding.top,
            child: Padding(
              padding: EdgeInsets.only(left: .0),
              child: _spacingContainer(width: height * 0.12, height: height),
            ),
          ),
          _blurEffect(
              width: height - height * 0.12,
              height: height,
              sigmaX: 10.0,
              sigmaY: 10.0),
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
                    Center(
                      child: _labelsGroup(),
                    ),
                    favouriteButton,
                    Container(
                      height: 90,
                      child: controllers,
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

}
