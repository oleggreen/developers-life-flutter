import 'package:developerslife_flutter/main_screen/selected_category.dart';
import 'package:developerslife_flutter/model/categories.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data_provider.dart';
import '../main.dart';

class MyDrawerWidget extends StatelessWidget {
  final SelectedCategory _selectedCategoryModel;

  Category get selectedCategory => _selectedCategoryModel.selectedCategory;

  MyDrawerWidget(this._selectedCategoryModel);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 240.0,
            child: DrawerHeader(
              padding: EdgeInsets.only(left: 40, top: 20, right: 30, bottom: 20),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Image.asset('assets/images/logo.png'),
                  Positioned(
                      bottom: 10.0,
                      left: 12.0,
                      child: Text("Developers life", style: TextStyle(fontSize: 16, color: darkGreyColor)))
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          createMenuItem(context, Category.LATEST, Icons.home),
          createMenuItem(context, Category.TOP, Icons.star),
          createMenuItem(context, Category.MONTHLY, Icons.star_half),
          createMenuItem(context, Category.HOT, Icons.flash_on),
          Divider(height: 1, color: darkGreyColor),
          createMenuItem(context, Category.RANDOM, Icons.autorenew),
          createMenuItem(context, Category.FAVORITE, Icons.thumb_up),
        ],
      ),
    );
  }

  Widget createMenuItem(BuildContext context, Category category, IconData iconData) {
    var titleTextByCategory = getTitleTextByCategory(category, context);
    var textColor = category == selectedCategory ? Colors.orange : darkGreyColor;
    var bgColor = category == selectedCategory ? lightGreyColor : Colors.transparent;

    return Container(
        decoration: BoxDecoration(color: bgColor),
        child: ListTile(
          selected: category == selectedCategory,
          leading: Icon(iconData, color: textColor),
          title: Text(titleTextByCategory, style: TextStyle(color: textColor, fontSize: 18)),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Fluttertoast.showToast(msg: "Selected: " + titleTextByCategory);
            Navigator.pop(context);

            _selectedCategoryModel.selectCategory(category);
          },
        ));
  }
}
