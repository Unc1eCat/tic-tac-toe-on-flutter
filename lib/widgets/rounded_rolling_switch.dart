import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/utils/listenable_utils.dart';

typedef OnChanged = void Function(bool value);

class RoundedRollingSwitch extends StatefulWidget {
  final bool initialValue;
  final IconData iconOn;
  final IconData iconOff;
  final Color colorOn;
  final Color colorOff;
  final Color boxColor;
  final double elevation;
  final BorderRadius borderRadius;
  final Duration animationDuration;
  final OnChanged onChanged;

  const RoundedRollingSwitch({
    @required this.onChanged,
    Key key,
    this.initialValue = false,
    this.iconOn = Icons.check_rounded,
    this.iconOff = Icons.close_rounded,
    this.colorOn,
    this.colorOff,
    this.boxColor,
    this.elevation = 3.6,
    this.borderRadius,
    this.animationDuration,
  }) : super(key: key);

  @override
  _RoundedRollingSwitchState createState() => _RoundedRollingSwitchState();
}

class _RoundedRollingSwitchState extends State<RoundedRollingSwitch> with TickerProviderStateMixin {
  AnimationController _anim;
  AnimationController _press;

  bool _value;
  set value(bool newValue) {
    setState(() => _value = newValue);
    widget.onChanged(newValue);
  }

  bool get value => _value;

  @override
  void initState() {
    _value = widget.initialValue;
    _anim = AnimationController(vsync: this, duration: widget.animationDuration ?? Duration(milliseconds: 200));
    _press = AnimationController(vsync: this, duration: widget.animationDuration ?? Duration(milliseconds: 130), value: 1.0);

    super.initState();
  }

  @override
  void dispose() {
    _anim.dispose();
    _press.dispose();

    super.dispose();
  }

  void _onTapUp(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _press.animateTo(1.0).then((_) => value = !value);
      _press.removeStatusListener(_onTapUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorOff = widget.colorOff ?? Theme.of(context).cardColor.blendedWithInversion(0.7);
    final colorOn = widget.colorOn ?? Theme.of(context).accentColor;
    final boxColor = widget.boxColor ?? Theme.of(context).cardColor.withRangedHsvValue(1.2);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(11);

    _anim.animateTo(value ? 1.0 : 0.0);

    return AnimatedBuilder(
      animation: MultiListenable.from([_anim, _press]),
      builder: (context, child) {
        return SizedBox(
          height: 30,
          width: 50,
          child: GestureDetector(
            onTapDown: (_) {
              if (!_press.isAnimating) {
                _press.animateTo(0.0);
              }
            },
            onTapCancel: () => _press.animateTo(1.0),
            onTapUp: (_) {
              if (_press.status == AnimationStatus.completed) {
                _press.animateTo(1.0).then((_) => value = !value);
              } else {
                _press.addStatusListener(_onTapUp);
              }
            },
            child: Material(
              borderRadius: borderRadius,
              elevation: widget.elevation,
              shadowColor: Color.lerp(colorOff, colorOn, _anim.value),
              color: Color.lerp(colorOff, colorOn, _anim.value),
              child: Align(
                alignment: Alignment(_anim.value * 2 - 1, 0),
                child: Transform.scale(
                  scale: 0.2 * _press.value + 0.8,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(1.6),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: boxColor,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: _anim.value * math.pi,
                              child: Opacity(
                                opacity: 1 - _anim.value,
                                child: Icon(
                                  widget.iconOff,
                                  size: 16,
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: _anim.value * math.pi - math.pi,
                              child: Opacity(
                                opacity: _anim.value,
                                child: Icon(
                                  widget.iconOn,
                                  size: 16,
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
          ),
        );
      },
      child: null,
    );
  }
}

// TODO: PUT IT ALL INTO A RENDER BOX
