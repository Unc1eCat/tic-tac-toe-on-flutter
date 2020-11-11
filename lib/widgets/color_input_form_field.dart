import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';

typedef void OnColorCangedCallback(Color newValue);

class ColorInput extends StatefulWidget {
  final OnColorCangedCallback onChanged;
  final Color initialValue;

  const ColorInput({Key key, this.onChanged, this.initialValue}) : super(key: key);

  @override
  _ColorInputState createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  Color color;

  @override
  void didChangeDependencies() {
    color = widget.initialValue; // Maybe it will call the widget.onChanged callback after initial value change
    super.didChangeDependencies();
  }

  void _changeColor(Color newColor)
  {
    // TODO: Complete
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 30, minWidth: 60),
      child: WhiteButton(
        alignment: Alignment.centerRight,
        onPressed: () {/* Open color picker */},
        bodyColor: color.withOpacity(0.6),
        borderColor: color,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.color_lens),
        ),
      ),
    );
  }
}
