import 'dart:math';

import 'package:flutter/material.dart';

import 'package:developerslife_flutter/model/categories.dart';
import 'package:developerslife_flutter/data_provider.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';

class PostItemModel with ChangeNotifier {

  final PostItem postItem;
  bool activated = false;

  PostItemModel(this.postItem);

  void setActive(bool activate) {
    if (activated != activate) {
      activated = activate;
      notifyListeners();
    }
  }

  void toggle() {
    activated = !activated;
    notifyListeners();
  }
}

enum PostListState {
  IDLE, LOADING, ERROR, DONE
}

class PostListModel with ChangeNotifier {
  static const int ITEMS_PER_PAGE = 5;

  Category _selectedCategory;
  List<PostItemModel> _items = List();
  int _totalCount;

  PostListState state;
  List<PostItemModel> get items => _items;

//  GifsList(Category selectedCategory, List<PostItem> items, int totalCount) {
//    verifyCorrectness(items);
//    this._selectedCategory = selectedCategory;
//    this._items = items.map((item) => PostItemModel(item)).toList();
//    this.totalCount = totalCount;
//  }

  Future loadCategory(Category selectedCategory) async {
    _items.clear();
    state = PostListState.LOADING;
    notifyListeners();

    this._selectedCategory = selectedCategory;
    getData(_selectedCategory, 0).then((result) {
      _items = result.item2.result.map((item) => PostItemModel(item)).toList();
      _totalCount = result.item2.totalCount;
      state = PostListState.IDLE;
      notifyListeners();

    }).catchError((error) {
      print(error);
      state = PostListState.ERROR;
      notifyListeners();
    });
  }

  Future reLoadCurrentCategory() async {
    _items.clear();
    state = PostListState.LOADING;

    getData(_selectedCategory, 0).then((result) {
      _items = result.item2.result.map((item) => PostItemModel(item)).toList();
      _totalCount = result.item2.totalCount;
      state = PostListState.IDLE;
      notifyListeners();

    }).catchError((error) {
      print(error);
      state = PostListState.ERROR;
      notifyListeners();
    });
  }

  void loadMore() {
    if (state == PostListState.LOADING) return;

    int pageToLoad = _items.length ~/ ITEMS_PER_PAGE;

    state = PostListState.LOADING;
    notifyListeners();

    getData(_selectedCategory, pageToLoad)
        .then((value) {
      var pageNumberLoaded = value.item1;
      var pageItemsLoaded = value.item2;

      verifyCorrectness(pageItemsLoaded.result);

      var newList = List<PostItemModel>();
      newList.addAll(_items.getRange(0, min(_items.length, pageNumberLoaded * ITEMS_PER_PAGE)));
      newList.addAll(pageItemsLoaded.result.map((item) => PostItemModel(item)));

      _items.clear();
      _items.addAll(newList);

      state = PostListState.IDLE;
      notifyListeners();

    }, onError: (error) {
      print(error);
      state = PostListState.ERROR;
      notifyListeners();
    });
  }

  bool isAllItemsLoaded() {
    return _totalCount == _items.length;
  }

  void verifyCorrectness(List<PostItem> postItems) {
    postItems.forEach((postItem) {
      if (postItem.type != "gif") {
        throw Exception("Cannot handle any post type except 'gif'");
      }
    });
  }

  void setAutoLoadGifs(bool autoLoad) {
    _items.forEach((item) => item.setActive(autoLoad));
  }
}