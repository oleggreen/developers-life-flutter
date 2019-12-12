import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'RestService.dart';
import 'model/PostItem.dart';
import 'model/PostResponse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Developers Lite'),
    );
  }
}

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

/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<Tuple2<int, PostResponse>> getData(String category, int pageNumber) async {
  print("getData: category=" + category + ", page=" + pageNumber.toString() );

  final dio = Dio();
  final client = RestClient(dio);
  var response = await client.getPosts(category, pageNumber);

  print("getData:result: ${response.result.toString()}");
  return Tuple2(pageNumber, response);
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedCategory = RestClient.LATEST_CATEGORY;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

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
          title: Text(selectedCategory),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset('assets/images/ic_launcher.png'),
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              ListTile(
                title: Text('Latest'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Fluttertoast.showToast(msg: "Selected: Latest");
                  Navigator.pop(context);
                  setState(() {
                    selectedCategory = RestClient.LATEST_CATEGORY;
                  });
                },
              ),
              ListTile(
                title: Text('Best'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Fluttertoast.showToast(msg: "Selected: Best");
                  Navigator.pop(context);
                  setState(() {
                    selectedCategory = RestClient.TOP_CATEGORY;
                  });
                },
              ),
              ListTile(
                title: Text('Hot'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Fluttertoast.showToast(msg: "Selected: Hot");
                  Navigator.pop(context);
                  setState(() {
                    selectedCategory = RestClient.HOT_CATEGORY;
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: Color(0xffcfcfcf),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder(
                future: getData(selectedCategory, 0),
                builder: (context, snapshot) {
                  var resultTuple = snapshot.data;
                  if (resultTuple == null) {
                    print("rebuilding_list. data is null");
                    return Center(child: CircularProgressIndicator());

                  } else {
                    var response = resultTuple.item2;
                    var items = List<PostItem>();
                    items.addAll(response.result);
                    print("rebuilding_list. " + items.toString());
                    return PostListWidget(this, selectedCategory, items);
                  }
                }),
          ),
        ));
  }
}

class PostListWidget extends StatefulWidget {

  static const int ITEMS_PER_PAGE = 5;
  final List<PostItem> items;
  final _MyHomePageState parent;
  final String selectedCategory;

  PostListWidget(this.parent, this.selectedCategory, this.items);

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
        newList.addAll(widget.items);

        newList.addAll(widget.items.getRange(0, min(widget.items.length, pageNumberLoaded * PostListWidget.ITEMS_PER_PAGE)));
        newList.addAll(pageItemsLoaded.result);

        widget.items.clear();
        widget.items.addAll(newList);

      }, onError: (error) {
        print(error);
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    print("_PostListWidgetState.build: " + widget.selectedCategory + " " + widget.items.toString());

    return NotificationListener<ScrollNotification>(
      // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
//          print("scrollInfo: [" + scrollInfo.metrics.pixels.toString() + " : " + scrollInfo.metrics.maxScrollExtent.toString() + "]");
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500) {
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
                return Center(child: CircularProgressIndicator());

              } else {
                var curTheme = Theme.of(context);
                var postItem = widget.items[index];

                return buildListPostWidget(postItem, curTheme);
              }
            })
    );
  }

  Widget buildListPostWidget(PostItem postItem, ThemeData curTheme) {
    return Card(
      elevation: 2,
      child: Container(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
//                decoration: BoxDecoration(
//                    boxShadow: [
//                      BoxShadow(
//                        color: Color(0xffacacac),
//                        blurRadius: 1.0, // has the effect of softening the shadow
//                        spreadRadius: 1.0, // has the effect of extending the shadow
//                        offset: Offset(
//                          0.0, // horizontal, move right 10
//                          0.0, // vertical, move down 10
//                        ),
//                      )
//                    ],
//                    color: Colors.white,
//                    borderRadius: BorderRadius.circular(10.0)),

                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        postItem.description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff626262)
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          fit: StackFit.loose,
                          children: <Widget>[
                            Image.network(
                              postItem.previewURL,
                              height: 216,
                              frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: child,
                                );
                              },
                            ),
                            Image.network(
                              postItem.gifURL,
                              height: 216,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null)
                                  return Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: child,
                                  );

                                return Container(
                                  height: 220,
                                  alignment: Alignment.topCenter,
                                  child:Container(
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
                      ),

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
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff949494)
                                          ),
                                        ),
                                        Text(
                                          "Rating: " + postItem.votes.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff949494)
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: curTheme.primaryColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7), bottomRight: Radius.circular(7))
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 1),
                                          decoration: BoxDecoration(
                                              color: curTheme.primaryColorLight,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => Share.share("https://developerslife.ru/" + postItem.id.toString()),
                                            icon: Icon(
                                                Icons.insert_link,
                                                color: curTheme.primaryColor
                                            ),
                                          ),
                                        ),
//                                        ShareButtonWidget(postItem.gifURL)
                                        Theme.of(context).platform == TargetPlatform.iOS
                                            ? Container()
                                            : Container(
                                          margin: EdgeInsets.only(left: 1),
                                          decoration: BoxDecoration(
                                              color: curTheme.primaryColorLight,
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => Share.share(postItem.gifURL),
                                            icon: Icon(
                                                Icons.share,
                                                color: curTheme.primaryColor
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),),
                              ]
                          )
                      ),
                    ])));
  }
}

class ShareButtonWidget extends StatefulWidget {

  final String textToShare;

  ShareButtonWidget(this.textToShare);

  @override
  State<StatefulWidget> createState() => _ShareButtonWidgetState(textToShare);
}

class _ShareButtonWidgetState extends State<ShareButtonWidget> {

  Color _myColor = Colors.green;

  String textToShare;

  _ShareButtonWidgetState(this.textToShare);

  @override
  Widget build(BuildContext context) {
    var curTheme = Theme.of(context);

    return new GestureDetector(
        child: Container(
            margin: EdgeInsets.only(left: 1),
            decoration: BoxDecoration(
              color: _myColor,
            ),
            child: IconButton(
              onPressed: () => {},//Share.share(textToShare),
              icon: Icon(
                  Icons.share,
                  color: curTheme.primaryColor
              ),
            ),
        ),
        onTapDown: (tapDownDetails) {
          print("Tap: onTapDown");
          setState(() {
            _myColor = Colors.white;
          });
        },
        onTapUp: (tapUpDetails) {
          print("Tap: onTapUp");
          setState(() {
            _myColor = curTheme.primaryColorLight;
          });
        },
//        onTap: () {
//          setState(() {
//            if (_myColor == Colors.green) {
//              _myColor = Colors.orange;
//            }
//            else {
//              _myColor = Colors.green;
//            }
//          });
//        }
    );
//        return Container(
//      margin: EdgeInsets.only(left: 1),
//      decoration: BoxDecoration(
//        color: curTheme.primaryColorLight,
//      ),
//      child: IconButton(
//        onPressed: () => Share.share(postItem.gifURL),
//        icon: Icon(
//            Icons.share,
//            color: curTheme.primaryColor
//        ),
//      ),
//    );
  }
}
