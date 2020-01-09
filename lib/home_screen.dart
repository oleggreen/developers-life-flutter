import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

import 'package:provider/provider.dart';
import 'categories.dart';
import 'data_provider.dart';
import 'localizations.dart';
import 'main.dart';
import 'model/PostItem.dart';
import 'model/PostResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_prefs.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Category selectedCategory = Category.LATEST;

  bool autoLoadGifs = false;

  @override
  Widget build(BuildContext context) {
//    _isAutoLoadGifs().
//    autoLoadGifs = _isAutoLoadGifs();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          brightness: Brightness.dark,
          title: Consumer<UserPrefs>(
            builder: (context, userPrefs, _) {
              print("UserPrefs: Consumer().builder ${userPrefs.loadGifUrlsPref}");
              return Text("load gifs: " + userPrefs.loadGifUrlsPref.toString(), style: TextStyle(color: Colors.white));
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
                              child: Row(
                                  children: [
                                    Checkbox(value: autoLoadGifs, onChanged: (checked) {
                                      setState(() {
                                        _check(checked);
                                      });
                                    }),
                                    Text(DemoLocalizations
                                        .of(context)
                                        .auto_load_gifs
                                    )
                                  ]
                              )
                          ),
                        );
                    },
                  );
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
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
                          bottom: 10.0, left: 12.0, child: Text("Developers life", style: TextStyle(fontSize: 16, color: darkGreyColor)))
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
        ),
        body: Container(
          color: lightGreyColor,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder(
                future: getData(selectedCategory, 0),
                builder: (context, snapshot) {
                  var resultTuple = snapshot.data;
                  if (snapshot.connectionState != ConnectionState.done) {
                    print("rebuilding_list. data is null");
                    return Center(child: CircularProgressIndicator());

                  } else {
                    PostResponse response = resultTuple.item2;
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
                      return PostListWidget(this, selectedCategory, items, response.totalCount);
                    }
                  }
                }),
          ),
        ));
  }

  PopupMenuItem<MenuItem> buildPopupMenuItem(BuildContext context) {
    return PopupMenuItem(
        value: MenuItem.AUTO_LOAD_GIFS,
        child: Row(
            children: [
              Checkbox(value: autoLoadGifs, onChanged: (checked) {
                setState(() {
                  _check(checked);
                });
              }),
              Text(DemoLocalizations
                  .of(context)
                  .auto_load_gifs)
            ]
        )
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
            setState(() {
              selectedCategory = category;
            });
          },
        ));
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
    Provider.of<UserPrefs>(context, listen: false)
        .setLoadGifUrlsPref(autoLoadGifs);
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

enum MenuItem {
  AUTO_LOAD_GIFS
}

class PostListWidget extends StatefulWidget {
  static const int ITEMS_PER_PAGE = 5;
  final List<PostItem> items;
  final _MyHomePageState parent;
  final Category selectedCategory;
  final int totalCount;

  PostListWidget(this.parent, this.selectedCategory, this.items, this.totalCount);

  @override
  State<StatefulWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  void loadMore() {
    setState(() {
      int pageToLoad = widget.items.length ~/ PostListWidget.ITEMS_PER_PAGE;
      getData(widget.selectedCategory, pageToLoad).then((value) {
        var pageNumberLoaded = value.item1;
        var pageItemsLoaded = value.item2;

        var newList = List<PostItem>();
        newList.addAll(widget.items.getRange(0, min(widget.items.length, pageNumberLoaded * PostListWidget.ITEMS_PER_PAGE)));
        newList.addAll(pageItemsLoaded.result);

        widget.items.clear();
        widget.items.addAll(newList);
      }, onError: (error) {
        print(error);
      });
    });
  }

  bool isAllItemsLoaded() {
    return widget.totalCount == widget.items.length;
  }

  @override
  Widget build(BuildContext context) {
    print("_PostListWidgetState.build: " + widget.selectedCategory.toString() + " " + widget.items.toString());

    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500 && !isAllItemsLoaded()) {
            loadMore();
          }
        },

        child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: widget.items.length + 1,
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 2,
                  color: Colors.transparent,
                ),
            itemBuilder: (BuildContext context, int index) {
              if (index == widget.items.length) {
                if (isAllItemsLoaded()) {
                  return SizedBox(
                    height: 10,
                    width: 10,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              } else {
                var curTheme = Theme.of(context);
                var postItem = widget.items[index];

                return buildListPostWidget(postItem, curTheme);
              }
            })
    );
  }

  Widget buildListPostWidget(PostItem postItem, ThemeData curTheme) {
    var votesCount = postItem.votes;
    return Card(
        elevation: 2,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
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
                          frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
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
                        2 == 2 ? Text("asfafasdf") : Spacer(),
//                        Expanded(
//                          child: Column(
//                              mainAxisSize: MainAxisSize.max,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(
//                                  "Author: " + postItem.author,
//                                  softWrap: false,
//                                  overflow: TextOverflow.fade,
//                                  textAlign: TextAlign.start,
//                                  style: TextStyle(fontSize: 14, color: greyColor),
//                                ),
//                                Text(
//                                  "Rating: " + votesCount.toString(),
//                                  overflow: TextOverflow.ellipsis,
//                                  textAlign: TextAlign.start,
//                                  softWrap: false,
//                                  style: TextStyle(fontSize: 14, color: votesCount > 100 ? curTheme.primaryColor : greyColor),
//                                ),
//                              ]),
//                        ),
                        sharePostLinkWidget(curTheme, postItem),
                        sharePostLinkWidget2(curTheme, postItem),
                      ])),
            ])));
  }

  Widget sharePostLinkWidget2(ThemeData curTheme, PostItem postItem) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return Container(
        decoration: BoxDecoration(color: curTheme.primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(7))),
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
          ),),);
    } else {
      return Container();
    }
  }

  Widget sharePostLinkWidget(ThemeData curTheme, PostItem postItem) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return Container(
          decoration: BoxDecoration(color: curTheme.primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(7))),
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

class GifImageWidget extends StatefulWidget {
  final PostItem postItem;

  GifImageWidget(this.postItem);

  @override
  _GifImageWidgetState createState() => _GifImageWidgetState();
}

class _GifImageWidgetState extends State<GifImageWidget> {

  bool userRequested = false;
  bool loadGif = false;
  bool pressed = false;

  _GifImageWidgetState();

  @override
  Widget build(BuildContext context) {
//    print("_GifImageWidgetState: build $loadGif : ${widget.autoLoadGifUrls}");
    return Consumer<UserPrefs>(
      builder: (context, userPrefs, _) {
        print("UserPrefs: Consumer().builder $loadGif");
        if (!userRequested) {
          loadGif = userPrefs.loadGifUrlsPref;
          print("UserPrefs: Consumer().builder overriden: $loadGif");
        }
        return Listener(
          onPointerDown: (event) =>
              setState(() {
                pressed = !pressed;
              }),
          onPointerCancel: (event) =>
              setState(() {
                pressed = false;
              }),
          onPointerUp: (event) {
            print("UserPrefs: onPointerUp");
            userRequested = true;
            loadGif = !loadGif;
            pressed = false;
            setState(() => {});
          },
          child: Column(
            children: [
              loadGifOrEmpty(loadGif),
            ],
          ),
        );
      },
    );
  }

  Widget loadGifOrEmpty(bool loadGif) {
    if (loadGif) {
      return Image.network(
        widget.postItem.gifURL,
        height: 276,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null)
            return Padding(
              padding: EdgeInsets.all(2.0),
              child: child,
            );

          return Container(
            height: 280,
            alignment: Alignment.topCenter,
            child: Container(
              height: 3.0,
              child: LinearProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        height: 160,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: ShapeDecoration(color: pressed ? Color(0x99000000) : Color(0x77000000), shape: CircleBorder()),
        child: LayoutBuilder(builder: (context, constraint) {
          return Icon(Icons.play_arrow, color: pressed ? Colors.white : Color(0x77ffffff), size: constraint.biggest.height);
        }),
      );
    }
  }
}
