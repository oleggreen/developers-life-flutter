import 'dart:io';
import 'package:developerslife_flutter/main_screen/gif_image.dart';
import 'package:developerslife_flutter/main_screen/gifs_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:provider/provider.dart';
import '../data_provider.dart';
import '../localizations.dart';
import '../main.dart';
import '../network/model/PostItem.dart';
import '../network/model/PostResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer_menu.dart';
import 'selected_category.dart';
import 'user_prefs.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool autoLoadGifs = false;

  @override
  Widget build(BuildContext context) {
//    _isAutoLoadGifs().
//    autoLoadGifs = _isAutoLoadGifs();
    return Consumer<SelectedCategory>(
        builder: (context, selectedCategoryModel, _) => Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                brightness: Brightness.dark,
                title: Consumer<UserPrefs>(
                  builder: (context, userPrefs, _) {
                    print("UserPrefs: Consumer().builder ${userPrefs.loadGifUrlsPref}");
                    return Text("load gifs: " + userPrefs.loadGifUrlsPref.toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
//          title: Text(getTitleTextByCategory(selectedCategory, context), style: TextStyle(color: Colors.white)),
                iconTheme: new IconThemeData(color: Colors.white),
                actions: [
                  FutureBuilder(
                    future: _isAutoLoadGifs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return PopupMenuButton<MenuItem>(
                          onSelected: _select,
                          itemBuilder: (BuildContext context) {
                            return List()
                              ..add(
                                PopupMenuItem(
                                    value: MenuItem.AUTO_LOAD_GIFS,
                                    child: Row(children: [
                                      Checkbox(
                                          value: autoLoadGifs,
                                          onChanged: (checked) {
                                            setState(() {
                                              _check(checked);
                                            });
                                          }),
                                      Text(DemoLocalizations.of(context).auto_load_gifs)
                                    ])),
                              );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              drawer: MyDrawerWidget(selectedCategoryModel),
              body: Container(
                color: lightGreyColor,
                child: Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: FutureBuilder(
                      future: getData(selectedCategoryModel.selectedCategory, 0),
                      builder: (context, snapshot) {
                        var resultTuple = snapshot.data;

                        if (snapshot.connectionState != ConnectionState.done) {
                          print("rebuilding_list. data is null");
                          return Center(child: CircularProgressIndicator());
                        } else {
                          PostResponse response = resultTuple?.item2;
                          if (snapshot.hasError) {
                            return Text("Some error occured");
                          } else if (response.totalCount == 0) {
                            return Container(
                              padding: EdgeInsets.all(40),
                              alignment: Alignment.center,
                              child: Text(
                                "This category is empty",
                                style: TextStyle(fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            var items = List<PostItem>();
                            items.addAll(response.result);
                            print("rebuilding_list. " + items.toString());

                            return ChangeNotifierProvider(
                              create: (_) =>
                                  GifsList(selectedCategoryModel.selectedCategory, items, response.totalCount),
                              child: PostListWidget(),
                            );
                          }
                        }
                      }),
                ),
              ),
            ));
  }

  PopupMenuItem<MenuItem> buildPopupMenuItem(BuildContext context) {
    return PopupMenuItem(
        value: MenuItem.AUTO_LOAD_GIFS,
        child: Row(children: [
          Checkbox(
              value: autoLoadGifs,
              onChanged: (checked) {
                setState(() {
                  _check(checked);
                });
              }),
          Text(DemoLocalizations.of(context).auto_load_gifs)
        ]));
  }

  void _select(MenuItem menuItem) {
    if (menuItem == MenuItem.AUTO_LOAD_GIFS) {
      _check(!autoLoadGifs);
    }
  }

  void _check(bool checked) {
    autoLoadGifs = checked;
    _setAutoLoadGifs(autoLoadGifs);
    print("UserPrefs: Provider.of().setLoadGifUrlsPref() $autoLoadGifs");
    Provider.of<UserPrefs>(context, listen: false).setLoadGifUrlsPref(autoLoadGifs);
  }

  final autoLoadGifsTag = 'autoLoadGifs';

  _setAutoLoadGifs(bool autoLoad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoLoadGifsTag, autoLoad);
  }

  Future<bool> _isAutoLoadGifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(autoLoadGifsTag) ?? false;
  }
}

enum MenuItem { AUTO_LOAD_GIFS }

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GifsList>(
      builder: (context, gifsList, _) => NotificationListener<ScrollNotification>(
          // ignore: missing_return
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500 && !gifsList.isAllItemsLoaded()) {
              gifsList.loadMore();
            }
          },
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: gifsList.items.length + 1,
              separatorBuilder: (BuildContext context, int index) => Divider(
                    height: 2,
                    color: Colors.transparent,
                  ),
              itemBuilder: (BuildContext context, int index) {
                if (index == gifsList.items.length) {
                  if (gifsList.isAllItemsLoaded()) {
                    return SizedBox(
                      height: 10,
                      width: 10,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                } else {
                  var curTheme = Theme.of(context);
                  var postItem = gifsList.items[index];

                  return buildListPostWidget(postItem, curTheme);
                }
              })),
    );
  }

  Widget buildListPostWidget(PostItemModel postItemModel, ThemeData curTheme) {
    var postItem = postItemModel.postItem;
    var votesCount = postItem.votes;
    return Card(
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
                            child: Image.network(
                              postItem.previewURL,
                              height: 276,
                              frameBuilder:
                                  (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: child,
                                );
                              },
                            )),
                        GifImageWidget(postItem),
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
                            Expanded(
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
                            ),
                            sharePostLinkWidget(curTheme, postItem),
                            sharePostLinkWidget2(curTheme, postItem),
                          ])),
                ])));
  }

  Widget sharePostLinkWidget2(ThemeData curTheme, PostItem postItem) {
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

  Widget sharePostLinkWidget(ThemeData curTheme, PostItem postItem) {
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
