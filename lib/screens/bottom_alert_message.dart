import 'dart:ui';

import 'package:my_utilities/color_utils.dart';
import 'package:flutter/material.dart';

class BottomAlertMessage<T> extends TransitionRoute<T> {
  final Widget header;
  final List<Widget> buttons;

  BottomAlertMessage({
    @required this.header,
    this.buttons,
  });

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.9, sigmaY: 0.9),
        child: ColoredBox(
          color: Colors.black45,
        ),
      ),
    );
    yield OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              _BottomAlertDialogCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: header,
                ),
              ),
              SizedBox(
                height: 500,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 26,
                  mainAxisSpacing: 12,
                  children: List<Widget>.generate(
                    buttons.length,
                    (i) => AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset((i + 1).isOdd ? -1 : 0, 0),
                          end: Offset((i + 1).isOdd ? -1 : 0, 0),
                        ).animate(animation),
                        child: header,
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Card(
                          // color: Theme.of(context).cardTheme.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                            side: BorderSide(
                              width: 1.4,
                              color: Theme.of(context).cardTheme.color.blendedWithInversion(0.03),
                            ),
                          ),
                          margin: const EdgeInsets.all(12),
                          child: buttons[i],
                        ),
                      ),
                      // _BottomAlertDialogCard(child: buttons[i]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 320);
}

class _BottomAlertDialogCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const _BottomAlertDialogCard({
    this.child,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ASSSFTGHUJIKO");
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
        minHeight: 120,
      ),
      child: Card(
        color: color ?? Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            width: 1.4,
            color: (color ?? Theme.of(context).cardTheme.color).blendedWithInversion(0.03),
          ),
        ),
        margin: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
