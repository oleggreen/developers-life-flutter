import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

import 'network/RestService.dart';
import 'model/categories.dart';
import 'package:dio/dio.dart';
import 'network/model/PostItem.dart';
import 'network/model/PostResponse.dart';

import 'package:tuple/tuple.dart';

import 'localizations.dart';

/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<Tuple2<int, PostResponse>> getData(Category category, int pageNumber) async {
  print("getData: category=" + category.toString() + ", page=" + pageNumber.toString());

  if (kIsWeb || Platform.isMacOS) {
    var dataString = await getFileData("assets/best_of_all_time.json");
    print("getData:result: " + dataString);
    PostResponse data = PostResponse.fromJsonMap(json.decode(dataString));
    return Tuple2(pageNumber, data);

  } else {
    final dio = Dio();
    final client = RestClient(dio);

    PostResponse response;
    if (category == Category.RANDOM) {
      response = await getRandomPosts(client);

    } else {
      response = await client.getPosts(getUrlByCategory(category), pageNumber);
    }

    print("getData:result: ${response.result.toString()}");
    return Tuple2(pageNumber, response);
  }
}

Future<PostResponse> getRandomPosts(RestClient client) async {
  List<PostItem> randomItems = List();
  randomItems.add(await client.getRandomPost());
  randomItems.add(await client.getRandomPost());
  randomItems.add(await client.getRandomPost());
  randomItems.add(await client.getRandomPost());
  randomItems.add(await client.getRandomPost());

  return PostResponse(result: randomItems, totalCount: -1);
}

// ignore: missing_return
String getUrlByCategory(Category category) {
  switch (category) {
    case Category.LATEST:
      return RestClient.LATEST_CATEGORY;
    case Category.TOP:
      return RestClient.TOP_CATEGORY;
    case Category.MONTHLY:
      return RestClient.MONTHLY_CATEGORY;
    case Category.HOT:
      return RestClient.HOT_CATEGORY;
    case Category.RANDOM:
      return null;
    case Category.FAVORITE:
      return null;
  }
}

// ignore: missing_return
String getTitleTextByCategory(Category category, BuildContext context) {
  switch(category) {
    case Category.LATEST: return DemoLocalizations.of(context).latest;
    case Category.TOP: return DemoLocalizations.of(context).bestOfAllTime;
    case Category.MONTHLY: return DemoLocalizations.of(context).bestOfTheMonth;
    case Category.HOT: return DemoLocalizations.of(context).hot;
    case Category.RANDOM: return DemoLocalizations.of(context).random;
    case Category.FAVORITE: return DemoLocalizations.of(context).favorite;
  }
}
