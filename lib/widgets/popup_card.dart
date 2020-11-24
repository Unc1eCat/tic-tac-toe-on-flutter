import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';

class PopupCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  PopupCard({
    this.child,
    this.margin = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: margin,
      shadowColor: Colors.transparent,
      color: Theme.of(context).dialogBackgroundColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1.2,
          color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.4),
        ),
      ),
      child: child,
    );
  }
}
