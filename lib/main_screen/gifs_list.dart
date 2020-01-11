import 'dart:math';

import 'package:flutter/material.dart';

import '../model/categories.dart';
import '../data_provider.dart';
import '../network/model/PostItem.dart';

class PostItemModel with ChangeNotifier {

  final PostItem postItem;
  bool activated = false;

  PostItemModel(this.postItem);

  void setActive(bool activate) {
    activated = activate;
    notifyListeners();
  }
}

class GifsList with ChangeNotifier {
  static const int ITEMS_PER_PAGE = 5;

  Category selectedCategory;
  List<PostItemModel> _items = List();
  int totalCount;

  List<PostItemModel> get items => _items;

  GifsList(Category selectedCategory, List<PostItem> items, int totalCount) {
    verifyCorrectness(items);
    this.selectedCategory = selectedCategory;
    this._items = items.map((item) => PostItemModel(item)).toList();
    this.totalCount = totalCount;
  }

  void loadMore() {
      int pageToLoad = _items.length ~/ ITEMS_PER_PAGE;
      getData(selectedCategory, pageToLoad).then((value) {
        var pageNumberLoaded = value.item1;
        var pageItemsLoaded = value.item2;

        verifyCorrectness(pageItemsLoaded.result);

        var newList = List<PostItemModel>();
        newList.addAll(_items.getRange(0, min(_items.length, pageNumberLoaded * ITEMS_PER_PAGE)));
        newList.addAll(pageItemsLoaded.result.map((item) => PostItemModel(item)));

        _items.clear();
        _items.addAll(newList);

        notifyListeners();

      }, onError: (error) {
        print(error);
      });
    }

  bool isAllItemsLoaded() {
    return totalCount == _items.length;
  }

  void verifyCorrectness(List<PostItem> postItems) {
    postItems.forEach((postItem) {
      if (postItem.type != "gif") {
        throw Exception("Cannot handle any post type except 'gif'");
      }
    });
  }
}