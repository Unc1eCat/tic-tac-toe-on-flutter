import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';

import 'heavy_touch_butotn.dart';

class BeautifulButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double pressedScale;

  const BeautifulButton({
    Key key,
    @required this.child,
    @required this.onPressed, this.pressedScale = 0.85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeavyTouchButton(
      pressedScale: pressedScale,
      onPressed: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(Theme.of(context).primaryColor, Colors.pink[600], 0.02).withOpacity(0.8),
              Colors.black.blendedWithInversion(0.12).withOpacity(0.8),
              Color.lerp(Theme.of(context).primaryColor, Colors.deepOrange[600], 0.04).withOpacity(0.8),
            ],
            stops: const [0.05, 0.65, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 15)),
        ),
        child: child,
      ),
    );
  }
}
