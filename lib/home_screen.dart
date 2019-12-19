import 'dart:io';
import 'dart:math';
import 'package:developerslife_flutter/second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

import 'package:flutter/services.dart' show PlatformException, MethodChannel;

import 'categories.dart';
import 'data_provider.dart';
import 'main.dart';
import 'model/PostItem.dart';
import 'model/PostResponse.dart';

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

const platform = const MethodChannel("test_activity");

_getNewActivity() async {
  try {
    await platform.invokeMethod('startNewActivity');
  } on PlatformException catch (e) {
    print(e.message);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Category selectedCategory = Category.LATEST;

  @override
  Widget build(BuildContext context) {
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
          title: Text(getTitleTextByCategory(selectedCategory), style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
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

  Widget createMenuItem(BuildContext context, Category category, IconData iconData) {
    var titleTextByCategory = getTitleTextByCategory(category);
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

    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = screenWidth > 800 ? 2 : 1;

    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500 && !isAllItemsLoaded()) {
            loadMore();
          }
        },

//        child: GridView.builder(
//            padding: const EdgeInsets.all(8),
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, childAspectRatio: 3 / 2),
//            itemCount: widget.items.length + 1,
//            itemBuilder: (BuildContext context, int index) {
//
//              if (index == widget.items.length) {
//                if (isAllItemsLoaded()) {
//                  return SizedBox(height: 10, width: 10,);
//
//                } else {
//                  return Center(child: CircularProgressIndicator());
//                }
//
//              } else {
//                var curTheme = Theme.of(context);
//                var postItem = widget.items[index];
//
//                return buildListPostWidget(postItem, curTheme);
//              }
//            })
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
            }));
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
              GestureDetector(
                  onLongPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute(postItem)),
                      ),
                  child: Container(
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
                        //                        CachedNetworkImage(
                        //                          imageUrl: postItem.previewURL,
                        //                          height: 276,
                        //                          errorWidget: (context, url, error) => Icon(Icons.error),
                        //                        ),
                        Image.network(
                          postItem.gifURL,
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
                        )
                      ],
                    ),
                  )),
              Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
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
                                Text(
                                  "Rating: " + votesCount.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14, color: votesCount > 100 ? curTheme.primaryColor : greyColor),
                                ),
                              ]),
                        ),
                        sharePostLinkWidget(curTheme, postItem),
                        openAndroidActivityWidget(curTheme),
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
              )));
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

  Widget openAndroidActivityWidget(ThemeData curTheme) {
    if (!kIsWeb && Platform.isAndroid) {
      return Container(
          decoration: BoxDecoration(
            color: curTheme.primaryColor,
          ),
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 1, right: 1),
          child: ButtonTheme(
              minWidth: 20.0,
              height: 10.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(),
                child: Icon(Icons.launch, color: curTheme.primaryColor),
                onPressed: () => _getNewActivity(),
                color: curTheme.primaryColorLight,
                textColor: Colors.white,
                splashColor: Colors.white,
              )));
    } else {
      return Container();
    }
  }
}
