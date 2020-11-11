import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';

class SlotHighlightment extends StatefulWidget {
  final Color color;
  final Widget child;

  const SlotHighlightment({Key key, @required this.color, this.child}) : super(key: key);

  @override
  _SlotHighlightmentState createState() => _SlotHighlightmentState();
}

class _SlotHighlightmentState extends State<SlotHighlightment> with TickerProviderStateMixin {
  AnimationController _animContr;
  Animation<double> _anim;
  Animation<double> _animOpacity;

  @override
  void initState() {
    Random rand = Random();
    _animContr = AnimationController(vsync: this, duration: Duration(milliseconds: 400 + (rand.nextDouble() * 500).toInt()));
    _anim = CurvedAnimation(parent: _animContr, curve: Curves.elasticOut);
    _animOpacity = CurvedAnimation(parent: _animContr, curve: Curves.easeOutSine);
    _animContr.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScaleTransition(
          scale: _anim,
          child: FadeTransition(
            opacity: _animOpacity,
            child: Card(
              color: widget.color.withRangedHsvSaturation(0.8).withOpacity(0.6),
              margin: const EdgeInsets.all(10),
              shadowColor: widget.color.withOpacity(0.4),
              elevation: 3.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: SizedBox.expand(),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
