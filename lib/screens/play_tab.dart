import 'package:flutter/material.dart';
import 'package:my_utilities/flutter/widgets/gradient_button.dart';
import 'package:my_utilities/color_utils.dart';
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
            padding: const EdgeInsets.all(10),
            // child: SingleDeviceGameButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SingleDeviceGameButton(),
          ),
          // Hero(
          //   tag: 0,
          //   child: GradientButton(
          //     // padding: const EdgeInsets.all(20),
          //     gradient: LinearGradient(
          //       colors: [
          //         Colors.blue[200].withRangedHsvSaturation(0.73),
          //         Colors.indigoAccent[200].withRangedHsvSaturation(0.55),
          //         Colors.blueAccent[100],
          //       ],
          //       stops: [
          //         0.3,
          //         0.7,
          //         1.0,
          //       ],
          //       begin: Alignment.centerLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.symmetric(
          //             vertical: 16,
          //             horizontal: 8,
          //           ),
          //           child: Text(
          //             "Play on this device",
          //             style: Theme.of(context).textTheme.headline5.copyWith(
          //                   color: Colors.white,
          //                 ),
          //           ),
          //         ),
          //         Spacer(),
          //         Icon(
          //           Icons.play_circle_outline,
          //           size: 46,
          //           color: Colors.white,
          //         ),
          //       ],
          //     ),
          //     onPressed: () {
          //       // Navigator.of(context).pushNamed(GameScreen.ROUTE_NAME);
          //       setState(() => lobby = true);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
