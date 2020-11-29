import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/game_screen.dart';
import 'screens/tabs_screen.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

void main() {
  EquatableConfig.stringify = true;
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  @override
  TheAppState createState() => TheAppState();

  static TheAppState of(BuildContext context) {
    return context.findAncestorStateOfType<TheAppState>();
  }

  static Future<void> openPatreon() async {
    if (await ul.canLaunch("https://www.patreon.com/user?u=27971705")) {
      print("sfa");
      await ul.launch("https://www.patreon.com/user?u=27971705");
    }
  }
}

class TheAppState extends State<TheApp> {
  Locale _locale;
  set appLocale(Locale newLocale) => setState(() => this._locale = newLocale);
  Locale get appLocale => Locale(_locale.languageCode, _locale.countryCode);

  ThemeMode _theme = ThemeMode.system;
  set theme(ThemeMode newValue) {
    SharedPreferences.getInstance().then((pref) => pref.setInt("themeIndex", theme.index));

    setState(() => this._theme = newValue);
  }

  ThemeMode get theme => _theme;

  Future<void> loadPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    var rebuild = false;

    if (prefs.containsKey("themeIndex")) {
      _theme = ThemeMode.values[prefs.getInt("themeIndex")];
      rebuild = true;
    }

    if (prefs.containsKey("languageLocaleLanguageCode")) {
      _locale = Locale(prefs.getString("languageLocaleLanguageCode"), prefs.getString("languageLocaleCountryCode") ?? null);
      rebuild = true;
    }

    if (rebuild) {
      setState(() {});
    }
  }

  @override
  Future<void> initState() {
    loadPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: theme,
      locale: _locale,
      supportedLocales: [
        Locale("en"),
        Locale("ru"),
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      localizationsDelegates: [
        AppLocalizations
            .delegate, // TODO: Create own translations system where translations of other languages is stored on a remote server
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.light().copyWith(
        accentColor: Colors.lightBlueAccent[400],
        cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          color: Color(0xFFA0A1A2),
          shadowColor: Color(0xC81E1E1E),
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
              color: Color(0xC2878787),
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
          highlightColor: Colors.white24,
        ),
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.w500,
          ),
          caption: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            wordSpacing: 1.8,
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
        splashColor: Colors.blueGrey.withOpacity(0.2),
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.lightBlueAccent[400],
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
            // fontWeight: FontWeight.w500,
          ),
          bodyText2: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            wordSpacing: 1.8,
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
