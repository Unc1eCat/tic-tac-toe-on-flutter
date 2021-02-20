import 'package:flutter/material.dart';
import 'package:my_utilities/flutter/widgets/gradient_button.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/widgets/online_game_button.dart';
import 'package:tic_tac_toe/widgets/single_device_game_button.dart';
import 'game_screen.dart';

class PlayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: SingleDeviceGameButton(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: OnlineGameButton(),
          ),
        ],
      ),
    );
  }
}
