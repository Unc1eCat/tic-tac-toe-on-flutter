import 'package:flutter/material.dart';

class HeavyTouchButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration animationDuration;

  /// Scale when the button is pressed. Unpressed is 1.0
  final double pressedScale;

  /// Whether to trigger full animation even on short press
  final bool fullAnimation;

  const HeavyTouchButton({
    @required this.onPressed,
    Key key,
    this.child,
    this.animationDuration,
    this.pressedScale = 0.75,
    this.fullAnimation = true,
  }) : super(key: key);

  @override
  _HeavyTouchButtonState createState() => _HeavyTouchButtonState();
}

class _HeavyTouchButtonState extends State<HeavyTouchButton> with TickerProviderStateMixin {
  AnimationController _anim;

  @override
  void initState() {
    _anim = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? Duration(milliseconds: 120),
      lowerBound: widget.pressedScale,
      value: 1.0,
    );

    super.initState();
  }

  @override
  void dispose() {
    _anim.dispose();

    super.dispose();
  }

  void _onTapUp(AnimationStatus status) {
    if (!_anim.isAnimating && _anim.value <= widget.pressedScale) {
      _anim.removeStatusListener(_onTapUp);
      _anim.animateTo(1.0);
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _anim.animateBack(widget.pressedScale),
      onTapCancel: () => _anim.animateTo(1.0),
      onTapUp: (_) {
        if (widget.fullAnimation) {
          if (!_anim.isAnimating && _anim.value <= widget.pressedScale) {
            _anim.animateTo(1.0);
            widget.onPressed?.call();
          } else {
            _anim.addStatusListener(_onTapUp);
          }
        } else {
          _anim.animateTo(1.0);
          widget.onPressed?.call();
        }
      },
      child: ScaleTransition(
        scale: _anim,
        child: widget.child,
      ),
    );
  }
}
// TODO: COMPLETE IT!! ITS VERY BEAUTIFUL. MAKE IT WORK ON RENDERING LAYER
