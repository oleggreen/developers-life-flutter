// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get latest {
    return Intl.message(
      'Latest',
      name: 'latest',
      desc: '',
      args: [],
    );
  }

  String get bestOfAllTime {
    return Intl.message(
      'Best of all time',
      name: 'bestOfAllTime',
      desc: '',
      args: [],
    );
  }

  String get bestOfTheMonth {
    return Intl.message(
      'Best of the Month',
      name: 'bestOfTheMonth',
      desc: '',
      args: [],
    );
  }

  String get hot {
    return Intl.message(
      'Hot',
      name: 'hot',
      desc: '',
      args: [],
    );
  }

  String get random {
    return Intl.message(
      'Random',
      name: 'random',
      desc: '',
      args: [],
    );
  }

  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  String get autoLoadGifs {
    return Intl.message(
      'Auto load all gifs',
      name: 'autoLoadGifs',
      desc: '',
      args: [],
    );
  }

  String get failToLoadDataMsg {
    return Intl.message(
      'Fail to load data',
      name: 'failToLoadDataMsg',
      desc: '',
      args: [],
    );
  }

  String get failToLoadDataRecommendation {
    return Intl.message(
      'Check your internet connection\n and try to swipe down ↓ to reload.',
      name: 'failToLoadDataRecommendation',
      desc: '',
      args: [],
    );
  }

  String get emptyStateMsg {
    return Intl.message(
      'Nothing to show',
      name: 'emptyStateMsg',
      desc: '',
      args: [],
    );
  }

  String get emptyStateDetails {
    return Intl.message(
      'Seems that this category is empty.',
      name: 'emptyStateDetails',
      desc: '',
      args: [],
    );
  }

  String get endOfPosts {
    return Intl.message(
      'The end',
      name: 'endOfPosts',
      desc: '',
      args: [],
    );
  }

  String get failToLoadNewPosts {
    return Intl.message(
      'Failed to load',
      name: 'failToLoadNewPosts',
      desc: '',
      args: [],
    );
  }

  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  String get pageHomeConfirm {
    return Intl.message(
      'Confirm',
      name: 'pageHomeConfirm',
      desc: '',
      args: [],
    );
  }

  String pageHomeWelcome(dynamic name) {
    return Intl.message(
      'Welcome $name',
      name: 'pageHomeWelcome',
      desc: '',
      args: [name],
    );
  }

  String pageHomeWelcomeGender(dynamic gender) {
    return Intl.gender(
      gender,
      male: 'Hi man!',
      female: 'Hi woman!',
      other: 'Hi there!',
      name: 'pageHomeWelcomeGender',
      desc: '',
      args: [gender],
    );
  }

  String pageNotificationsCount(dynamic howMany) {
    return Intl.plural(
      howMany,
      one: '1 message',
      other: '$howMany messages',
      name: 'pageNotificationsCount',
      desc: '',
      args: [howMany],
    );
  }

  String get pageNotificationsCount2 {
    return Intl.message(
      'Yes',
      name: 'pageNotificationsCount2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('uk', ''), Locale('en', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}