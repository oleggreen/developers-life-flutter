import 'package:developerslife_flutter/generated/l10n.dart';
import 'package:developerslife_flutter/main_screen/view_model/selected_category_model.dart';
import 'package:developerslife_flutter/model/categories.dart';
import 'package:flutter/material.dart';

import 'package:developerslife_flutter/data_provider.dart';
import 'package:developerslife_flutter/main.dart';
import 'package:provider/provider.dart';

class MyDrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedCategory>(
        builder: (context, selectedCategoryModel, _) {
          var selectedCategory = selectedCategoryModel.selectedCategory;
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
                            child: Text(S.of(context).devLifeName, style: TextStyle(fontSize: 16, color: darkGreyColor)))
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                createMenuItem(context, Category.LATEST, selectedCategory, Icons.home),
                createMenuItem(context, Category.TOP, selectedCategory, Icons.star),
                createMenuItem(context, Category.MONTHLY, selectedCategory, Icons.star_half),
                createMenuItem(context, Category.HOT, selectedCategory, Icons.flash_on),
                Divider(height: 1, color: darkGreyColor),
                createMenuItem(context, Category.RANDOM, selectedCategory, Icons.autorenew),
//                createMenuItem(context, Category.FAVORITE, selectedCategory, Icons.thumb_up),
              ],
            ),
          );
        }
    );
  }

  Widget createMenuItem(BuildContext context, Category category, Category selectedCategory, IconData iconData) {
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
//            Fluttertoast.showToast(msg: "Selected: " + titleTextByCategory);
            Navigator.pop(context);

            var viewModel = Provider.of<SelectedCategory>(context, listen: false);
            viewModel.selectCategory(category);
          },
        ));
  }
}
