import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:developerslife_flutter/data_provider.dart';
import 'package:developerslife_flutter/main_screen/view/gif_image.dart';
import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:developerslife_flutter/main_screen/view/main_menu.dart';
import 'package:developerslife_flutter/main_screen/view_model/selected_category_model.dart';
import 'package:developerslife_flutter/model/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:provider/provider.dart';
import 'package:developerslife_flutter/main.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';

import 'drawer_menu.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Provider.of<SelectedCategory>(context, listen: false).loadInitialState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<SelectedCategory>(
                builder: (context, selectedCategoryModel, _) => buildScaffold(context, selectedCategoryModel.selectedCategory)
            );
          } else {
            return Container();
          }
        }
    );
  }

  Scaffold buildScaffold(BuildContext context, Category selectedCategory) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(getTitleTextByCategory(selectedCategory, context), style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: [
          createOverflowMenu()
        ],
      ),
      drawer: MyDrawerWidget(),
      body: Container(
        color: lightGreyColor,
        child: Center(
          child: Consumer<SelectedCategory>(
              builder: (context, selectedCategory, _) {
                var postListModel = Provider.of<PostListModel>(context, listen: false);
                postListModel.loadCategory(selectedCategory.selectedCategory);

                return Consumer<PostListModel>(
                    builder: (context, postListModel, _) {
                      if (postListModel.items.isEmpty) {
                        if (postListModel.state == PostListState.LOADING) {
                          return Center(child: CircularProgressIndicator());
                        } else if (postListModel.state == PostListState.ERROR) {
                          return Text("Some error occured");
                        } else {
                          return PostListWidget();
                        }
                      } else {
                        return PostListWidget();
                      }
                    });
              }),
        ),
      ),);
  }
}

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Consumer<PostListModel>(
        builder: (context, gifsList, _) =>
            RefreshIndicator(
              onRefresh: () => gifsList.reLoadCurrentCategory(),
              child: NotificationListener<ScrollNotification>(
                // ignore: missing_return
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500 && !gifsList.isAllItemsLoaded()) {
                      gifsList.loadMore();
                    }
                  },
                  child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: gifsList.items.length + 1,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            height: 2,
                            color: Colors.transparent,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == gifsList.items.length) {
                          if (gifsList.isAllItemsLoaded()) {
                            return Align(alignment: Alignment.center, child: Text("The end"));
                          } else {
                            return Center(child: CircularProgressIndicator(backgroundColor: Colors.black));
                          }
                        } else {
                          var curTheme = Theme.of(context);
                          var postItem = gifsList.items[index];

                          return ChangeNotifierProvider.value(
                              value: postItem,
                              child: buildListItemWidget(postItem.postItem, curTheme));
                        }
                      })),
            ),
      );
  }

  Widget buildListItemWidget(PostItem postItem, ThemeData curTheme) {
    return
        Card(
            elevation: 2,
            child: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    postItem.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: darkGreyColor),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(color: Colors.black),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      fit: StackFit.loose,
                      children: <Widget>[
                        Hero(
                            tag: postItem.previewURL,
                            child: Image(
                              image: CachedNetworkImageProvider(postItem.previewURL),
                              height: 276,
                              frameBuilder:
                                  (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: child,
                                );
                              },
                            )),
                        GifImageWidget(),
                      ],
                    ),
                  ),
                  Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildPostInfoWidget(postItem, curTheme),
                            buildSharePostLinkButton(curTheme, postItem),
                            buildShareGifLinkButton(curTheme, postItem),
                          ])),
                ])));
  }

  Widget buildPostInfoWidget(PostItem postItem, ThemeData curTheme) {
    var votesCount = postItem.votes;
    return Expanded(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Author: " + postItem.author,
              softWrap: false,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: greyColor),
            ),
            Row(
              children: <Widget>[
                Text(
                  "Rating: " + votesCount.toString(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 14,
                      color: votesCount > 100 ? curTheme.primaryColor : greyColor),
                ),
                Icon(
                  Icons.star,
                  size: 17,
                  color: votesCount > 1000 ? curTheme.primaryColor : Colors.transparent,
                )
              ],
            ),
          ]),
    );
  }

  Widget buildShareGifLinkButton(ThemeData curTheme, PostItem postItem) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return Container(
        decoration: BoxDecoration(
            color: curTheme.primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(7))),
        padding: EdgeInsets.only(top: 2, bottom: 2, left: 1, right: 2),
        child: ButtonTheme(
          minWidth: 20.0,
          height: 10.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
            ),
            child: Icon(Icons.share, color: curTheme.primaryColor),
            onPressed: () => Share.share(postItem.gifURL),
            color: curTheme.primaryColorLight,
            textColor: Colors.white,
            splashColor: Colors.white,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildSharePostLinkButton(ThemeData curTheme, PostItem postItem) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return Container(
          decoration:
              BoxDecoration(color: curTheme.primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(7))),
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 1),
          child: ButtonTheme(
              minWidth: 20.0,
              height: 10.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
                ),
                child: Icon(Icons.insert_link, color: curTheme.primaryColor),
                onPressed: () => Share.share("https://developerslife.ru/" + postItem.id.toString()),
                color: curTheme.primaryColorLight,
                textColor: Colors.white,
                splashColor: Colors.white,
              )));
    } else {
      return Container();
    }
  }
}
