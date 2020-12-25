import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/localization_utils.dart' as locutils;

import '../main.dart';

class LanguageSelector extends StatefulWidget {
  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  FixedExtentScrollController _contr;

  @override
  void didChangeDependencies() {
    _contr = FixedExtentScrollController(
      initialItem: locutils.localeAndLanguageName.keys.toList().indexOf(Localizations.localeOf(context)),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contr.dispose();
    super.dispose();
  }

  void _selectLanguage() => TheApp.of(context).appLocale = locutils.localeAndLanguageName.keys.elementAt(_contr.selectedItem);

  Widget _buildLanguageCard(String languageTitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
      child: Center(
        child: Text(
          languageTitle,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = locutils.localeAndLanguageName.keys.toList().indexOf(Localizations.localeOf(context));

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Stack(
              children: [
                ListWheelScrollView(
                  controller: _contr,
                  physics: FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  // squeeze: 0.8,
                  useMagnifier: true,
                  magnification: 1.2,
                  diameterRatio: 2.2,
                  itemExtent: 50,
                  children: [
                    for (var i = 0; i < locutils.localeAndLanguageName.length; i++)
                      _buildLanguageCard(
                          locutils.localeAndLanguageName.values.elementAt(i) + "  " + locutils.localeAndFlag.values.elementAt(i))
                  ],
                ),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 1.3,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Theme.of(context).accentColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                _selectLanguage();
                Navigator.of(context).pop();
              },
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).languageSelectorSelect,
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
