import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/game_screen.dart';
import 'screens/tabs_screen.dart';

void main() {
  EquatableConfig.stringify = true;
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  @override
  TheAppState createState() => TheAppState();

  static TheAppState of(BuildContext context)
  {
    return context.findAncestorStateOfType<TheAppState>();
  }
}

class TheAppState extends State<TheApp> {
  Locale _locale;
  set appLocale(Locale newLocale) => setState(() => this._locale = newLocale);
  Locale get appLocale => Locale(_locale.languageCode, _locale.countryCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: [
        Locale("en"),
        Locale("ru"),
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark().copyWith(
        cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          color: Color(0xFF202223),
          shadowColor: Color(0xE6343434),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            gapPadding: 10,
            borderSide: BorderSide(
              color: Color(0xC2505050),
            ),
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(),
          unselectedLabelColor: Colors.white54,
          labelColor: Colors.white,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.white38,
          indent: 2,
          endIndent: 2,
          space: 4,
          thickness: 1.2,
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.white38,
          highlightColor: Colors.white24,
        ),
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 16,
          ),
          headline5: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headline6: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        splashColor: Colors.white54.blendedWith(Colors.blue, 0.2),
      ),
      routes: {
        '/': (ctx) => TabsScreen(),
        GameScreen.ROUTE_NAME: (ctx) => GameScreen(),
      },
    );
  }
}
