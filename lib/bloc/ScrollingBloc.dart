import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:party_player/bloc/BlocInterface.dart';
import 'package:rxdart/rxdart.dart';

abstract class ScrollingBloc with BlocInterface {

  BehaviorSubject<ScrollDirection> _scrollSubject =
  BehaviorSubject.seeded(ScrollDirection.idle);
  Observable<ScrollDirection> get scrollStream => _scrollSubject.stream;

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
  }

}