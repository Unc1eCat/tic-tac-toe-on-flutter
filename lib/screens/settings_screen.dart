import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/widgets/animated_in_out.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  Widget _wrapInCard({Widget leading, Widget trailing, BuildContext context}) {
    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: Theme.of(context).cardTheme.color,
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    //     child: child,
    //   ),
    // );
    return Stack(
      // fit: StackFit.loose,
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Card(
              elevation: 4,
              child: SizedBox(
                width: double.infinity,
                child: leading,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: AnimatedIn(
            duration: Duration(milliseconds: 250),
            builder: (context, child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
            child: Card(
              elevation: 2,
              color: Theme.of(context).cardColor.blendedWithInversion(0.01),
              child: trailing,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _wrapInCard(
              context: context,
              trailing: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    underline: null,
                    value: Locale(AppLocalizations.of(context).localeName),
                    items: [
                      const DropdownMenuItem<Locale>(
                        child: Text("Russian"),
                        value: Locale("ru"),
                      ),
                      const DropdownMenuItem<Locale>(
                        child: Text("English"),
                        value: Locale("en"),
                      ),
                    ],
                    onChanged: (value) => TheApp.of(context).appLocale = value,
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  "Language",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            SizedBox(height: 20),
            _wrapInCard(
              context: context,
              trailing: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                child: SizedBox(width: 60, height: 40),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  "Some setting",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
