import 'package:flutter/material.dart';
import 'package:tic_tac_toe/main.dart';
import '../widgets/beautiful_button.dart';
import 'package:my_utilities/flutter/widgets/icon_text.dart';

class PausedScreen extends StatelessWidget {
  static const routeName = "/pausedScreen";

  final VoidCallback restartCallback;

  PausedScreen(this.restartCallback);

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed, BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: BeautifulButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 38,
              color: Colors.white.withOpacity(0.95),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.button.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment(1.0, 0.5),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(
                      TheApp.localization(context).gamePauseRestart,
                      Icons.replay,
                      () {
                        Navigator.of(context).pop();
                        restartCallback();
                      },
                      context,
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      TheApp.localization(context).gamePauseExit,
                      Icons.exit_to_app,
                      () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/");
                      },
                      context,
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      TheApp.localization(context).gamePauseResume,
                      Icons.play_arrow_rounded,
                      () => Navigator.of(context).pop(),
                      context,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(
                      TheApp.localization(context).gamePauseRestart,
                      Icons.replay,
                      () {
                        Navigator.of(context).pop();
                        restartCallback();
                      },
                      context,
                    ),
                    SizedBox(width: 20),
                    _buildButton(
                      TheApp.localization(context).gamePauseExit,
                      Icons.exit_to_app,
                      () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/");
                      },
                      context,
                    ),
                    SizedBox(width: 20),
                    _buildButton(
                      TheApp.localization(context).gamePauseResume,
                      Icons.play_arrow_rounded,
                      () => Navigator.of(context).pop(),
                      context,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
