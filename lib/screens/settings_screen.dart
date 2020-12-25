import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tic_tac_toe/widgets/settings_tile.dart';
import '../utils/golden_ration_utils.dart' as gr;
import 'package:tic_tac_toe/main.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/widgets/animated_in_out.dart';
import 'package:tic_tac_toe/widgets/credits.dart';
import 'package:tic_tac_toe/widgets/language_selector.dart';
import '../l10n/localization_utils.dart' as locutils;
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  Widget _wrapInButton({Widget child, BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.61803398875,
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
            color: Theme.of(context).cardColor.blendedWithInversion(0.025),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _wrapInCard({Widget leading, Widget trailing, BuildContext context}) {
    return SizedBox(
      // height: 100,
      child: SettingsTile(
        leading: leading,
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            SizedBox(height: 20),
            _wrapInCard(
              context: context,
              trailing: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: FlatButton(
                  onPressed: () => showDialog(
                    context: context,
                    child: LanguageSelector(),
                  ),
                  child: Text(locutils.localeAndLanguageName[Localizations.localeOf(context)]),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  AppLocalizations.of(context).settingsLanguageTitle,
                  style: Theme.of(context).textTheme.headline6,
                  softWrap: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            _wrapInCard(
              context: context,
              trailing: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: ToggleSwitch(
                  minHeight: 0,
                  minWidth: MediaQuery.of(context).size.width * gr.invphi * gr.invphi * gr.invphi * gr.invphi,
                  cornerRadius: 8,
                  labels: ["", "", ""],
                  activeBgColor: Theme.of(context).accentColor,
                  activeFgColor: Theme.of(context).colorScheme.onPrimary,
                  inactiveBgColor: Theme.of(context).cardColor.blendedWithInversion(0.025),
                  initialLabelIndex: TheApp.of(context).theme.index,
                  icons: [Icons.settings, Icons.wb_sunny_rounded, Icons.nightlight_round],
                  onToggle: (index) => TheApp.of(context).theme = ThemeMode.values[index],
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  AppLocalizations.of(context).settingsTheme,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            SizedBox(height: 20),
            _wrapInButton(
              context: context,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => showDialog(context: context, child: Crdits(), barrierColor: Colors.black87),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppLocalizations.of(context).settingsCredits,
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20 * 1.61803398875),
            SizedBox(
              height: (MediaQuery.of(context).size.width - 20) * (1 - 1 / 1.61803398875),
              width: double.infinity,
              child: Stack(
                // fit: StackFit.loose,
                children: [
                  Positioned(
                    top: 0,
                    bottom: (MediaQuery.of(context).size.width - 20) *
                        (1 - 1 / 1.61803398875) *
                        (1 - 1 / 1.61803398875),
                    right: 0,
                    left: 0,
                    child: Card(
                      elevation: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                              child: Text(
                                AppLocalizations.of(context).settingsSupportUs,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width - 20) * (1 - 1 / 1.61803398875)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: (MediaQuery.of(context).size.width - 20) *
                        (1 - 1 / 1.61803398875) *
                        (1 - 1 / 1.61803398875) *
                        (1 - 1 / 1.61803398875),
                    bottom: 0,
                    child: AnimatedIn(
                      duration: Duration(milliseconds: 250),
                      builder: (context, child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      ),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 20) * (1 - 1 / 1.61803398875) -
                            (MediaQuery.of(context).size.width - 20) *
                                (1 - 1 / 1.61803398875) *
                                (1 - 1 / 1.61803398875) *
                                (1 - 1 / 1.61803398875),
                        child: Card(
                          elevation: 2,
                          color: Theme.of(context).cardColor.blendedWithInversion(0.025),
                          child: InkWell(
                            onTap: () {
                              TheApp.openPatreon();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/images/patreon_button.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
