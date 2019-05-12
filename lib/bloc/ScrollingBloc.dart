import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:party_player/bloc/BlocInterface.dart';
import 'package:rxdart/rxdart.dart';


abstract class ScrollingBloc with BlocInterface {

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final PublishSubject<double> _scrollingOffsetSubject = PublishSubject();
  PublishSubject<double> get scrollingOffsetStream => _scrollingOffsetSubject.stream;

  BehaviorSubject<ScrollDirection> _scrollSubject = BehaviorSubject.seeded(ScrollDirection.idle);
  Observable<ScrollDirection> get scrollStream => _scrollSubject.stream;

  ScrollingBloc(){
    _scrollController.addListener( scrollingListener );
  }

  scrollingListener(){
    _scrollingOffsetSubject.sink.add(  _scrollController.offset );
  }

  addNotification(notification) {
    if (!_scrollSubject.isClosed) {
      if (notification is ScrollEndNotification)
        Future.delayed(Duration(milliseconds: 300),
                () {
              if (!_scrollSubject.isClosed)
                _scrollSubject.sink.add(ScrollDirection.idle);
            });
      else if (notification is ScrollUpdateNotification)
        _scrollSubject.sink.add(ScrollDirection.forward);
    }
  }

  @override
  void dispose() {
    _scrollSubject?.close();
    print('Scrolling bloc dipose');
    _scrollController.removeListener( scrollingListener );
    _scrollController?.dispose();
    _scrollingOffsetSubject?.close();
  }

}