import 'dart:ui';

import 'package:equatable/equatable.dart';

// class Language extends Equatable
// {
//   final Locale locale;
//   final String name;
//   final String emojiFlag;

//   Language(this.locale, this.name, this.emojiFlag);

//   @override
//   List<Object> get props => [locale];
  
// }

final Map<Locale, String> localeAndLanguageName = {
  Locale("en"): "English",
  Locale("ru"): "Russian",
  Locale("it"): "Italian",
  Locale("fr"): "French",
  Locale("ja"): "Japanes",
  Locale("ch"): "Chinese",
  Locale("ge"): "German",
};

final Map<Locale, String> localeAndFlag = {
  Locale("en"): "🇺🇸",
  Locale("ru"): "🇷🇺",
  Locale("it"): "🍕",
  Locale("fr"): "🇫🇷",
  Locale("jp"): "🇯🇵",
  Locale("cn"): "🇨🇳",
  Locale("de"): "🇩🇪",
};
