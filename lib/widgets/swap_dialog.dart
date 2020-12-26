import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import '../main.dart';
import '../utils/golden_ration_utils.dart' as gr;

class SwapDialog extends StatelessWidget {
  final String text;

  const SwapDialog(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            // height: 230,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  width: 1.4,
                  color: Theme.of(context).cardTheme.color.blendedWithInversion(0.03),
                ),
              ),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(text, style: Theme.of(context).textTheme.headline5),
              ),
            ),
          ),
        ),
        Positioned(
          right: 30,
          bottom: 30 * gr.phi,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                color: Theme.of(context).cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: BorderSide(
                    width: 1.4,
                    color: Theme.of(context).cardTheme.color.blendedWithInversion(0.03),
                  ),
                ),
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 60 * gr.phi,
                  height: 60,
                  child: Center(
                    child: Text(
                      TheApp.localization(context).pickerSwapSwap,
                      style: Theme.of(context).textTheme.button.copyWith(fontSize: 22, height: 1.3),
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
              SizedBox(height: 22),
              RaisedButton(
                color: Theme.of(context).cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: BorderSide(
                    width: 1.4,
                    color: Theme.of(context).cardTheme.color.blendedWithInversion(0.03),
                  ),
                ),
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 60 * gr.phi,
                  height: 60,
                  child: Center(
                    child: Text(
                      TheApp.localization(context).pickerSwapCancel,
                      style: Theme.of(context).textTheme.button.copyWith(fontSize: 22, height: 1.3),
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
