import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:my_utilities/color_utils.dart';
import 'animated_in_out.dart';

typedef void OnColorCangedCallback(Color newValue, ValueKey<int> changedPlayer);

class ColorOptionData {
  Color color;

  /// Null if the option is free
  ValueKey<int> occupierKey;

  ColorOptionData(this.color, this.occupierKey);
}

class ColorInput extends StatefulWidget {
  final OnColorCangedCallback onChanged;
  final List<ColorOptionData> colorData;
  final ValueKey<int> thisSign;

  const ColorInput({
    Key key,
    this.onChanged,
    @required this.colorData,
    @required this.thisSign,
  }) : super(key: key);

  @override
  _ColorInputState createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  ColorOptionData get colorData => widget.colorData.where((e) => e.occupierKey == widget.thisSign).first;

  void _changeColor(Color newColor, ValueKey<int> changedPlayer) {
    widget.onChanged(newColor, widget.thisSign);
  }

  void _openColorPicker() {
    var screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    var screenWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    RenderBox rb = context.findRenderObject();
    var position = rb.localToGlobal(Offset.zero);

    // position = Offset(
    //   position.dx,
    //   position.dy - MediaQuery.of(context).padding.top,
    // );

    var isUpper = position.dy > screenHeight / 2;
    var size = rb.size;
    var popupAreaSize = Size(
      screenWidth,
      isUpper ? position.dy - MediaQuery.of(context).padding.top - size.height : screenHeight - position.dy - size.height,
    );
    OverlayEntry entry;

    // print(isUpper);

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          AnimatedIn(
              duration: Duration(milliseconds: 80),
              builder: (context, child, anim) {
                return Listener(
                  onPointerDown: (_) => entry.remove(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2 * anim.value,
                      sigmaY: 2 * anim.value,
                    ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.4 * anim.value),
                    ),
                  ),
                );
              }),
          Positioned(
            top: isUpper ? MediaQuery.of(context).padding.top : position.dy + size.height,
            // bottom: ,
            left: 0,
            child: SizedBox(
              height: popupAreaSize.height,
              width: popupAreaSize.width,
              child: Align(
                alignment: Alignment(position.dx / screenWidth, isUpper ? 1 : -1),
                child: Card(
                  margin: EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: isUpper ? 16 : 4,
                    bottom: isUpper ? 4 : 16,
                  ),
                  color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: GridView.extent(
                    padding: const EdgeInsets.all(8),
                    maxCrossAxisExtent: 70,
                    children: [
                      ...widget.colorData
                          .map((e) => ColorOption(
                                color: e.color,
                                isOccupied: colorData.occupierKey != widget.thisSign,
                                isSelected: colorData.occupierKey == widget.thisSign,
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(entry);
  } // TODO: Move the "custom popup menu button in a separate widget"!!!!!

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 30, minWidth: 60),
      child: WhiteButton(
        alignment: Alignment.centerRight,
        onPressed: _openColorPicker,
        bodyColor: colorData.color.withOpacity(0.6),
        borderColor: colorData.color,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.color_lens),
        ),
      ),
    );
  }
}

class ColorOption extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final bool isOccupied;

  const ColorOption({Key key, this.color, this.isSelected, this.isOccupied}) : super(key: key);

  @override
  _ColorOptionState createState() => _ColorOptionState();
}

class _ColorOptionState extends State<ColorOption> with TickerProviderStateMixin {
  AnimationController
      _selectionContr; // TODO: It's to heavy to make all of the options have the controller. There is idea of a trick in me head to use on controller instead

  @override
  void didChangeDependencies() {
    _selectionContr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _selectionContr.animateTo(widget.isSelected ? 1 : 0);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _selectionContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _selectionContr,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.all(_selectionContr.value * 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: _selectionContr.value <= 0
                  ? null
                  : Border.all(color: Theme.of(context).colorScheme.onBackground, width: _selectionContr.value * 8),
              borderRadius: BorderRadius.circular(100),
              color: widget.color,
            ),
            child: widget.isOccupied ? child : null,
          ),
        );
      },
      child: Center(
        child: Icon(
          Icons.not_interested_rounded,
          size: 44,
        ),
      ),
    );
  }
}
