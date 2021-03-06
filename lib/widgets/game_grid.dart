import 'dart:async';

import 'package:my_utilities/math_utils.dart' as math;
import 'package:flutter/material.dart';

class GameGrid extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final double strokeWidth;
  final int gridWidth;
  final int gridHeight;
  final double shift;

  const GameGrid({
    Key key,
    this.child,
    this.padding = const EdgeInsets.all(0),
    this.strokeWidth = 5,
    this.gridWidth = 3,
    this.gridHeight = 3,
    this.shift = 0.3,
  }) : super(key: key);

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  AnimationController get animationController => _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    Timer(const Duration(milliseconds: 200), _controller.forward);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, con) {
      var yStep = con.maxHeight / widget.gridHeight;
      var xStep = con.maxWidth / widget.gridWidth;

      if (xStep < yStep) {
        yStep = xStep;
      } else {
        xStep = yStep;
      }

      var size = Size(
        xStep * widget.gridWidth - widget.padding.horizontal,
        yStep * widget.gridHeight - widget.padding.vertical,
      );

      return CustomPaint(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: widget.child,
        ),
        painter: GridPainter(
          padding: widget.padding,
          animation: _controller,
          gridHeight: widget.gridHeight,
          gridWidth: widget.gridWidth,
          shift: widget.shift,
        ),
      );
    });
  }
}

class GridPainter extends CustomPainter {
  final Animation<double> animation;
  final int gridWidth;
  final int gridHeight;
  final double shift; // From 0.0 to 1.0
  final EdgeInsets padding;
  final double strokeWidth;

  GridPainter({
    this.strokeWidth,
    this.padding,
    this.shift,
    this.animation,
    this.gridWidth,
    this.gridHeight,
  }) : super(repaint: animation);

  @override
  void paint(Canvas c, Size s) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    var yStep = s.height / gridHeight;
    var xStep = s.width / gridWidth;

    if (xStep < yStep) {
      yStep = xStep;
    } else {
      xStep = yStep;
    }

    // s = Size(, );

    // var a = Rect.fromLTWH(
    //     padding.left + (s.width - padding.horizontal - xStep * gridWidth) / 2,
    //     padding.top + (s.height - padding.vertical - yStep * gridHeight) / 2,
    //     xStep * gridWidth - padding.horizontal,
    //     yStep * gridHeight - padding.vertical);

    if (animation.isCompleted) {
      for (var i = 1; i < gridWidth; i++) {
        c.drawLine(Offset(xStep * i, 0), Offset(xStep * i, s.height), paint);
      }
      for (var i = 1; i < gridHeight; i++) {
        c.drawLine(Offset(0, yStep * i), Offset(s.width, yStep * i), paint);
      }
    } else {
      for (var i = 1; i < gridWidth; i++) {
        // TODO: Find a more optimized way to check for visibility of the lines
        var value = sequentiallyStartingAnimations(animation.value, i - 1, linesAmount, shift);
        if (value > 0) {
          c.drawLine(Offset(xStep * i, 0), Offset(xStep * i, s.height * value), paint);
        } else {
          return;
        }
      }
      for (var i = 1; i < gridHeight; i++) {
        // TODO: Find a more optimized way to check for visibility of the lines
        var value = sequentiallyStartingAnimations(animation.value, gridWidth + i - 2, linesAmount, shift);
        if (value > 0) {
          c.drawLine(Offset(0, yStep * i), Offset(s.width * value, yStep * i), paint);
        } else {
          return;
        }
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.animation != this.animation ||
        oldDelegate.gridHeight != this.gridHeight ||
        oldDelegate.gridWidth != this.gridWidth ||
        oldDelegate.shift != this.shift;
  }

  static double sequentiallyStartingAnimations(double t, int index, int linesAmount, double shift) {
    var o = 1 / linesAmount + shift * (1 - 1 / linesAmount); // Lerp between inverse of [[linesAmount]] and 1 via shift
    // print(math.clip(o * linesAmount * t - (o * linesAmount - 1) * index / (linesAmount - 1), 0.0, 1.0));
    return math.clip(o * linesAmount * t - (o * linesAmount - 1) * index / (linesAmount - 1), 0.0, 1.0);

    // return 1;
  }

  int get linesAmount => gridWidth + gridHeight - 2;
}
