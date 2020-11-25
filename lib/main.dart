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

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark().copyWith(
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
