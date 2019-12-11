import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';

import 'RestService.dart';
import 'model/PostItem.dart';
import 'model/PostResponse.dart';

final logger = Logger();

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

class _MyHomePageState extends State<MyHomePage> {
  final List<int> colorCodes = <int>[600, 500, 100];

  /// Assumes the given path is a text-file-asset.
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<PostResponse> getData() async {
    final dio = Dio();
    final client = RestClient(dio);
    var response = await client.getPosts(RestClient.LATEST_CATEGORY, 0);

    print("result: ${response.toString()}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
          title: Text(widget.title),
        ),
        body: Container(
          color: Color(0xffcfcfcf),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return snapshot.data != null ? listViewWidget(snapshot.data) : Center(child: CircularProgressIndicator());
                }),
          ),
        ));
  }

  ListView listViewWidget(PostResponse response) {
    List<PostItem> items = response.result;

    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 10,
          color: Colors.transparent,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffacacac),
                      blurRadius: 1.0, // has the effect of softening the shadow
                      spreadRadius: 1.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      items[index].description,
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
                            items[index].previewURL,
                            height: 216,
                            frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                              return Padding(
                                padding: EdgeInsets.all(2.0),
                                child: child,
                              );
                            },
                          ),
                          Image.network(
                            items[index].gifURL,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Author: " + items[index].author + items[index].author + items[index].author,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff949494)
                                      ),
                                    ),
                                    Text(
                                      "Rating: " + items[index].votes.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff949494)
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(color: Colors.green),
                                    child: IconButton(
                                      onPressed: () => print("link"),
                                      icon: Icon(Icons.insert_link),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: Colors.yellow),
                                    child: IconButton(
                                      onPressed: () => print("share"),
                                      icon: Icon(Icons.share),
                                    ),
                                  ),
                                ]
                            ),
//                            Column(
//                                mainAxisSize: MainAxisSize.min,
//                                crossAxisAlignment: CrossAxisAlignment.end,
//                                children: <Widget>[
//                                  new Text(
//                                    "New Column",
//                                    textAlign: TextAlign.start,
//                                    style: TextStyle(
//                                        fontSize: 16,
//                                        color: Color(0xff626262)
//                                    ),
//                                  ),
//                                ]
//                            ),
//                            Flexible(
//                                child: new Text(
//                                    items[index].description,
//                                    textAlign: TextAlign.start,
//                                    style: TextStyle(
//                                        fontSize: 16,
//                                        color: Color(0xff626262)
//                                    ),
//                                ),
//                            ),
//                            Text(
//                              items[index].description,
//                              textAlign: TextAlign.start,
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  color: Color(0xff626262)
//                              ),
//                            ),
                          ]
                      )
                    ),
                  ]));
        });
  }
}
