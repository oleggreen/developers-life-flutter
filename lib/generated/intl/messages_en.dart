// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(name) => "Welcome ${name}";

  static m1(gender) => "${Intl.gender(gender, female: 'Hi woman!', male: 'Hi man!', other: 'Hi there!')}";

  static m2(howMany) => "${Intl.plural(howMany, one: '1 message', other: '${howMany} messages')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "autoLoadGifs" : MessageLookupByLibrary.simpleMessage("Auto load all gifs"),
    "bestOfAllTime" : MessageLookupByLibrary.simpleMessage("Best of all time"),
    "bestOfTheMonth" : MessageLookupByLibrary.simpleMessage("Best of the Month"),
    "emptyStateDetails" : MessageLookupByLibrary.simpleMessage("Seems that this category is empty."),
    "emptyStateMsg" : MessageLookupByLibrary.simpleMessage("Nothing to show"),
    "endOfPosts" : MessageLookupByLibrary.simpleMessage("The end"),
    "failToLoadDataMsg" : MessageLookupByLibrary.simpleMessage("Fail to load data"),
    "failToLoadDataRecommendation" : MessageLookupByLibrary.simpleMessage("Check your internet connection\n and try to swipe down ↓ to reload."),
    "failToLoadNewPosts" : MessageLookupByLibrary.simpleMessage("Failed to load"),
    "favorite" : MessageLookupByLibrary.simpleMessage("Favorite"),
    "hot" : MessageLookupByLibrary.simpleMessage("Hot"),
    "latest" : MessageLookupByLibrary.simpleMessage("Latest"),
    "pageHomeConfirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "pageHomeWelcome" : m0,
    "pageHomeWelcomeGender" : m1,
    "pageNotificationsCount" : m2,
    "pageNotificationsCount2" : MessageLookupByLibrary.simpleMessage("Yes"),
    "random" : MessageLookupByLibrary.simpleMessage("Random"),
    "retry" : MessageLookupByLibrary.simpleMessage("Retry")
  };
}
