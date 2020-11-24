import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:my_utilities/color_utils.dart';

import 'popup_card.dart';

class SwapDialog extends StatelessWidget {
  final String text;

  const SwapDialog(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 230,
        child: PopupCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: Theme.of(context).textTheme.headline5),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WhiteButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Swap",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    SizedBox(width: 20),
                    WhiteButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
