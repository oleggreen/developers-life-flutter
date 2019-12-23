import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'latest': 'Latest',
      'best_of_all_time': 'Best of all time',
      'best_of_the_month': 'Best of the Month',
      'hot': 'Hot',
      'random': 'Random',
      'favorite': 'Favorite',
    },
    'uk': {
      'latest': 'Останні',
      'best_of_all_time': 'Найкращі за весь час',
      'best_of_the_month': 'Найкращі за місяць',
      'hot': 'Гарячі',
      'random': 'Випадкові',
      'favorite': 'Улюблені',
    },
  };

  String get latest => _localizedValues[locale.languageCode]['latest'];
  String get bestOfAllTime => _localizedValues[locale.languageCode]['best_of_all_time'];
  String get bestOfTheMonth => _localizedValues[locale.languageCode]['best_of_the_month'];
  String get hot => _localizedValues[locale.languageCode]['hot'];
  String get random => _localizedValues[locale.languageCode]['random'];
  String get favorite => _localizedValues[locale.languageCode]['favorite'];
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'uk'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}