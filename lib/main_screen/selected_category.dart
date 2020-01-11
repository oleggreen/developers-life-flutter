import 'package:flutter/material.dart';

import '../model/categories.dart';

class SelectedCategory with ChangeNotifier {

  Category _selectedCategory = Category.LATEST;

  Category get selectedCategory => _selectedCategory;

  void selectCategory(Category categoryToSelect) {
    if (_selectedCategory != categoryToSelect) {
      _selectedCategory = categoryToSelect;
      notifyListeners();
    }
  }
}