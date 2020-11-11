import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color bodyColor;
  final Color borderColor;
  final BorderRadius borderRadius;
  final Widget child;
  final Color highlightColor;
  final Color splashColor;
  final Alignment alignment;
  final bool opaqueBody;

  const WhiteButton({
    Key key,
    this.onPressed,
    this.alignment,
    this.bodyColor = Colors.white12,
    this.borderColor = Colors.white24,
    this.borderRadius,
    this.child,
    this.highlightColor = Colors.transparent,
    this.splashColor,
    this.opaqueBody = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var br = borderRadius ?? BorderRadius.circular(8);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        color: bodyColor,
        borderRadius: br,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: br,
          splashColor: splashColor,
          highlightColor: highlightColor,
          onTap: onPressed,
          child: Align(
            alignment: alignment ?? Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
