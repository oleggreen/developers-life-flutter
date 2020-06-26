// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
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
  String get localeName => 'uk';

  static m0(name) => "Welcome ${name}";

  static m1(gender) => "${Intl.gender(gender, female: 'Hi woman!', male: 'Hi man!', other: 'Hi there!')}";

  static m2(howMany) => "${Intl.plural(howMany, one: '1 message', other: '${howMany} messages')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appName" : MessageLookupByLibrary.simpleMessage("Developers Lite"),
    "authorLabel" : MessageLookupByLibrary.simpleMessage("Автор: "),
    "autoLoadGifs" : MessageLookupByLibrary.simpleMessage("Автоматично завантажувати Гіфки"),
    "bestOfAllTime" : MessageLookupByLibrary.simpleMessage("Найкращі за весь час"),
    "bestOfTheMonth" : MessageLookupByLibrary.simpleMessage("Найкращі за місяць"),
    "devLifeName" : MessageLookupByLibrary.simpleMessage("Життя розробників"),
    "emptyStateDetails" : MessageLookupByLibrary.simpleMessage("Здається ця категорія пуста."),
    "emptyStateMsg" : MessageLookupByLibrary.simpleMessage("Нічого немає"),
    "endOfPosts" : MessageLookupByLibrary.simpleMessage("Кінець"),
    "failToLoadDataMsg" : MessageLookupByLibrary.simpleMessage("Помилка завантаження"),
    "failToLoadDataRecommendation" : MessageLookupByLibrary.simpleMessage("Перевірте інтернет з\'єднання\n і проведіть пальцем вниз ↓ щоб перезавантажити дані."),
    "failToLoadNewPosts" : MessageLookupByLibrary.simpleMessage("Помилка завантаження"),
    "favorite" : MessageLookupByLibrary.simpleMessage("Улюблені"),
    "hot" : MessageLookupByLibrary.simpleMessage("Гарячі"),
    "latest" : MessageLookupByLibrary.simpleMessage("Останні"),
    "pageHomeConfirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "pageHomeWelcome" : m0,
    "pageHomeWelcomeGender" : m1,
    "pageNotificationsCount" : m2,
    "pageNotificationsCount2" : MessageLookupByLibrary.simpleMessage("Yes"),
    "postDetails" : MessageLookupByLibrary.simpleMessage("Деталі посту"),
    "random" : MessageLookupByLibrary.simpleMessage("Випадкові"),
    "ratingLabel" : MessageLookupByLibrary.simpleMessage("Рейтинг: "),
    "retry" : MessageLookupByLibrary.simpleMessage("Повторити")
  };
}
