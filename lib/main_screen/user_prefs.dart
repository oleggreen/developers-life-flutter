import 'package:flutter/material.dart';

class UserPrefs extends ChangeNotifier {

  bool loadGifUrlsPref = false;

//  UserPrefs({@required this.title, this.completed = false});

  void setLoadGifUrlsPref(bool load) {
    loadGifUrlsPref = load;
    notifyListeners();
  }
}