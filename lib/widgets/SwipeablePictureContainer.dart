import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class SwipeablePictureContainer extends StatelessWidget {
 final double width, height, elevation, cutRadius,
     horizontalSwipeMinDisplacement, horizontalSwipeMinVelocity,
     horizontalSwipeMaxHeightThreshold;

 final Object heroTag;
 final onSwipeLeft, onSwipeRight;
 final String imagePath, stickerText;

 SwipeablePictureContainer({this.width, this.height, this.cutRadius, this.elevation = 15.0,
     @required this.heroTag, this.onSwipeLeft, this.onSwipeRight,
   this.horizontalSwipeMaxHeightThreshold = 100.0,
   this.horizontalSwipeMinDisplacement = 4.0,
   this.horizontalSwipeMinVelocity = 5.0,
   this.imagePath,
   this.stickerText});

 @override
  Widget build(BuildContext context) {

   final labelDecoration = BoxDecoration(
       color: Colors.white.withOpacity(0.5),
       borderRadius: BorderRadiusDirectional.only(
         bottomEnd: Radius.circular(cutRadius),
       ),
   );

    return Container(
      color: Colors.transparent,
      width: width,
      height: height,
      child: new AspectRatio(
        aspectRatio: 1.0,

        child: Hero(
            tag: new GlobalKey(),
            child: Material(
              borderRadius:  BorderRadius.circular(cutRadius),
              color: Colors.transparent,
              elevation: 20.0,
              child: SwipeDetector(
                swipeConfiguration: SwipeConfiguration(
                    horizontalSwipeMinDisplacement: horizontalSwipeMinDisplacement,
                    horizontalSwipeMinVelocity: horizontalSwipeMinVelocity,
                    horizontalSwipeMaxHeightThreshold: horizontalSwipeMaxHeightThreshold ),
                onSwipeLeft: onSwipeLeft,
                onSwipeRight: onSwipeRight,

                child: InkWell(
                  onTap: (){},
                  onDoubleTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(cutRadius),
                        image: DecorationImage(
                            image: (imagePath == null) ?
                            AssetImage("images/music.jpg") :
                            FileImage(File(imagePath)), fit: BoxFit.cover) ),

                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: RectangleTriangleLabel(
                            size: width * 0.22,
                            decoration: labelDecoration,
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 4.0, bottom: 6.0),
                            child: Text(
                              stickerText,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}

class RectangleTriangleLabel extends StatelessWidget {
 final double size;
 final Decoration decoration;

 RectangleTriangleLabel({this.size, this.decoration = const BoxDecoration(
   color: Colors.white,
 )});

 @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipBehavior: Clip.antiAlias,
      clipper: TriangleClipper(),
      child: Container(
        decoration: decoration,
        width: size,
        height: size,

      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path>{
  
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(size.height, .0);
    path.lineTo(size.height, size.height );
    path.lineTo(.0, size.height);
    path.lineTo(size.height, .0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

