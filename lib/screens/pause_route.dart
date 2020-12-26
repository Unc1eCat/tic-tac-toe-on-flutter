import 'package:flutter/material.dart';
import 'dart:ui';

class PauseRoute<T> extends TransitionRoute<T> {
  final WidgetBuilder builder;

  PauseRoute(this.builder);

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: ColoredBox(
            color: Colors.blueGrey[100].withOpacity(0.3),
            child: SizedBox.expand(),
          ),
        ),
      ),
      maintainState: false,
      opaque: false,
    );
    yield OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ).animate(animation),
            child: child,
          );
        },
        child: builder(context),
      ),
      maintainState: false,
      opaque: false,
    );
  }
}
