import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs extends ChangeNotifier {
  final autoLoadGifsTag = 'autoLoadGifs';

  bool loadGifUrlsPref = false;

  loadInitialState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadGifUrlsPref = prefs.getBool(autoLoadGifsTag) ?? false;
  }

  void setLoadGifUrlsPref(bool load) {
    loadGifUrlsPref = load;
    notifyListeners();
  }
}