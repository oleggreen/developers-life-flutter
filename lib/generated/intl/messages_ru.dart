// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static m0(name) => "Welcome ${name}";

  static m1(gender) => "${Intl.gender(gender, female: 'Hi woman!', male: 'Hi man!', other: 'Hi there!')}";

  static m2(howMany) => "${Intl.plural(howMany, one: '1 message', other: '${howMany} messages')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appName" : MessageLookupByLibrary.simpleMessage("Developers Lite"),
    "authorLabel" : MessageLookupByLibrary.simpleMessage("Автор: "),
    "autoLoadGifs" : MessageLookupByLibrary.simpleMessage("Автоматически загружать Гифки"),
    "bestOfAllTime" : MessageLookupByLibrary.simpleMessage("Лучшие за все время"),
    "bestOfTheMonth" : MessageLookupByLibrary.simpleMessage("Лучшие за месяц"),
    "devLifeName" : MessageLookupByLibrary.simpleMessage("Жизнь разработчиков"),
    "emptyStateDetails" : MessageLookupByLibrary.simpleMessage("Кажется эта категория пуста."),
    "emptyStateMsg" : MessageLookupByLibrary.simpleMessage("Нечего показывать"),
    "endOfPosts" : MessageLookupByLibrary.simpleMessage("Конец"),
    "failToLoadDataMsg" : MessageLookupByLibrary.simpleMessage("Ошибка загрузки"),
    "failToLoadDataRecommendation" : MessageLookupByLibrary.simpleMessage("Проверте интернет соединение\n и проведите пальцем вниз ↓ чтоб перезагрузить данные."),
    "failToLoadNewPosts" : MessageLookupByLibrary.simpleMessage("Ошибка загрузки"),
    "favorite" : MessageLookupByLibrary.simpleMessage("Любимые"),
    "hot" : MessageLookupByLibrary.simpleMessage("Гарячие"),
    "latest" : MessageLookupByLibrary.simpleMessage("Последние"),
    "pageHomeConfirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "pageHomeWelcome" : m0,
    "pageHomeWelcomeGender" : m1,
    "pageNotificationsCount" : m2,
    "pageNotificationsCount2" : MessageLookupByLibrary.simpleMessage("Yes"),
    "random" : MessageLookupByLibrary.simpleMessage("Случайные"),
    "ratingLabel" : MessageLookupByLibrary.simpleMessage("Рейтинг: "),
    "retry" : MessageLookupByLibrary.simpleMessage("Повторить")
  };
}
