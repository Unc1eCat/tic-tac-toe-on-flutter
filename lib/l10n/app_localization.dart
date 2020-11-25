import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppLocalization {
  static Future<AppLocalization> load(Locale locale) {
    final name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  String appName() => Intl.message(
        "Tic-Tac-Toe",
        name: "appName",
        desc: "Name of the application",
      );

  String playOnThisDevice() => Intl.message(
        "Play on this device",
        name: "playOnThisDevice",
        desc: "Title of the single device lobby",
      );
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  static const supportedLocales = ["en", "ru"];

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return AppLocalization.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
