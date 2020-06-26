import 'dart:convert';
import 'dart:io';

import 'package:developerslife_flutter/model/categories.dart';
import 'package:developerslife_flutter/network/RestService.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';
import 'package:developerslife_flutter/network/model/PostResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';

import 'package:tuple/tuple.dart';

import 'package:developerslife_flutter/generated/l10n.dart';

const int ITEMS_PER_PAGE = 5;

/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<Tuple2<int, PostResponse>> getData(Category category, int pageNumber) async {
  print("getData: category=" + category.toString() + ", page=" + pageNumber.toString());

  if (kIsWeb || Platform.isMacOS) {
    var dataString = await getFileData("assets/best_of_all_time.json");
    print("getData: result: " + dataString);
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

    print("getData: result: ${response.result.toString()}");
    return Tuple2(pageNumber, response);
  }
}

//Future<PostItem> getRandomPostNotCoube(RestClient client) async {
//  client.getRandomPost().then(onValue);
//}

Future<PostResponse> getRandomPosts(RestClient client) async {
  var futuresList = Future.wait([
    client.getRandomPost(),
    client.getRandomPost(),
    client.getRandomPost(),
    client.getRandomPost(),
    client.getRandomPost()]);

  var randomItems = await futuresList;
  var filteredItems = randomItems
      .where((postItem) => postItem.type == AnimationType.GIF)
      .toList();

  if (filteredItems.length < ITEMS_PER_PAGE) {
    do {
      var randomPost = await client.getRandomPost();
      if (randomPost.type == AnimationType.GIF) {
        filteredItems.add(randomPost);
      }
    } while (filteredItems.length < ITEMS_PER_PAGE);
  }

  return PostResponse(result: filteredItems, totalCount: -1);
}

Future<PostItem> getPostDetails(int postId) async {
  final dio = Dio();
  final client = RestClient(dio);
  return await client.getPostDetails(postId);
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

String getTitleTextByCategory(Category category, BuildContext context) {
  switch(category) {
    case Category.LATEST: return S.of(context).latest;
    case Category.TOP: return S.of(context).bestOfAllTime;
    case Category.MONTHLY: return S.of(context).bestOfTheMonth;
    case Category.HOT: return S.of(context).hot;
    case Category.RANDOM: return S.of(context).random;
    case Category.FAVORITE: return S.of(context).favorite;
    default: return "unknown";
  }
}
