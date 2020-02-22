import 'package:developerslife_flutter/data_provider.dart';
import 'package:developerslife_flutter/main_screen/view/post_list.dart';
import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:developerslife_flutter/main_screen/view/main_menu.dart';
import 'package:developerslife_flutter/main_screen/view_model/selected_category_model.dart';
import 'package:developerslife_flutter/model/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:developerslife_flutter/main.dart';

import 'drawer_menu.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<CategoryModel>(context, listen: false).loadInitialState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<CategoryModel>(
                builder: (context, categoryModel, _) => buildScaffold(context, categoryModel));
          } else {
            return Container();
          }
        });
  }

  Scaffold buildScaffold(BuildContext context, CategoryModel categoryModel) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(getTitleTextByCategory(categoryModel.selectedCategory, context), style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: [createOverflowMenu()],
      ),
      drawer: MyDrawerWidget(),
      body: Container(
        color: lightGreyColor,
        child: Center(
          child: Consumer<CategoryModel>(builder: (context, selectedCategory, _) {
            var postListModel = Provider.of<PostListModel>(context, listen: false);

            print("buildScaffold: result: ${selectedCategory.selectedCategory.toString()}");
            postListModel.loadCategory(selectedCategory.selectedCategory);

            return PostListWidget();
          }),
        ),
      ),
    );
  }
}