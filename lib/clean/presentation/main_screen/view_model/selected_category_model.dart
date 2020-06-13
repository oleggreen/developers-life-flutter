import 'package:developerslife_flutter/clean/domain/entities/categories.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryModel with ChangeNotifier {
  final selectedCategoryTag = 'selectedCategory';

  Category _selectedCategory = Category.LATEST;

  Category get selectedCategory => _selectedCategory;

  loadInitialState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int catIndexCandidate = prefs.getInt(selectedCategoryTag) ?? Category.LATEST.index;
    int selectedCategoryIndex =
    catIndexCandidate < Category.values.length ? catIndexCandidate : Category.LATEST.index;

    Category selectedCategory = Category.values[selectedCategoryIndex];
    _selectedCategory = selectedCategory;
  }

  void selectCategory(Category categoryToSelect) {
    if (_selectedCategory != categoryToSelect) {
      _selectedCategory = categoryToSelect;
      notifyListeners();

      saveSelectedCategory(_selectedCategory);
    }
  }

  Future saveSelectedCategory(Category categoryToSave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(selectedCategoryTag, categoryToSave.index);
  }
}