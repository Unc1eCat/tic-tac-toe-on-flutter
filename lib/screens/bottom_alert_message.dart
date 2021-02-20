import 'dart:ui';

import 'package:my_utilities/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/heavy_touch_butotn.dart';

class BottomAlertMessageButton {
  final Widget child;
  final VoidCallback onPressed;

  BottomAlertMessageButton({
    @required this.child,
    @required this.onPressed,
  });
}

class BottomAlertMessage<T> extends TransitionRoute<T> {
  final Widget header;
  final List<BottomAlertMessageButton> buttons;

  BottomAlertMessage({
    @required this.header,
    this.buttons,
  });

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    final slideAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
    final opacityAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutSine);

    yield OverlayEntry(
      builder: (context) => FadeTransition(
        opacity: animation,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.9, sigmaY: 0.9),
          child: ColoredBox(
            color: Colors.black45,
          ),
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
              AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) => FadeTransition(
                        opacity: opacityAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -1),
                            end: Offset(0, 0),
                          ).animate(slideAnimation),
                          child: _BottomAlertDialogCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: header,
                            ),
                          ),
                        ),
                      )),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List<Widget>.generate(
                  buttons.length,
                  (i) => AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) => FadeTransition(
                      opacity: opacityAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, buttons.length - i.toDouble() + 0.5),
                          end: Offset(0, 0),
                        ).animate(slideAnimation),
                        child: HeavyTouchButton(
                          pressedScale: 0.85,
                          onPressed: buttons[i].onPressed,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: BorderSide(
                                width: 1.4,
                                color: Theme.of(context).cardTheme.color.blendedWithInversion(0.03),
                              ),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Center(
                                child: buttons[i].child,
                              ),
                            ),
                          ),
                        ),
                      ),
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
  Duration get transitionDuration => Duration(milliseconds: 620);
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
