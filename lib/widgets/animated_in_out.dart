import 'package:flutter/material.dart';

typedef Widget AnimatedBuilderCallback(BuildContext context, Widget child, Animation<double> animation);

class AnimatedIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final AnimatedBuilderCallback builder;

  const AnimatedIn({Key key, @required this.duration, @required this.builder, this.child}) : super(key: key);

  @override
  _AnimatedInState createState() => _AnimatedInState();
}

class _AnimatedInState extends State<AnimatedIn> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.animateTo(1);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) => widget.builder(context, child, _controller),
      child: widget.child,
    );
  }
}
