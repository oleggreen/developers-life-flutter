import 'dart:convert';

import 'package:flutter/material.dart';

import 'model/PostItem.dart';
import 'model/Response.dart';

import 'package:flutter/services.dart' show rootBundle;

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
  int _counter = 0;
  final List<int> colorCodes = <int>[600, 500, 100];

  /// Assumes the given path is a text-file-asset.
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<Response> getData() async {
//    Response list;
//    String link =
//        "https://developerslife.ru/top/1?json=true";
//    var res = await http
//        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//    print(res.body);
//    if (res.statusCode == 200) {
//      var data = json.decode(res.body);
//      var rest = data["articles"] as List;
//      print(rest);
//      list = rest.map<Article>((json) => Article.fromJson(json)).toList();
//    }
//    print("List Size: ${list.length}");
//    return list;

    String dataString = await getFileData("assets/best_of_all_time.json");
    var data = json.decode(dataString);

    var response = Response.fromJsonMap(data);
    response.result.forEach((postItem) => print(postItem.gifURL));
    print("result: ${response.toString()}");
    return response;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }),
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
////          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            //Text(
//            //  'You have pushed the button this many times:',
//            //),
//            //Text(
//            //  'count: $_counter',
//            //  style: Theme.of(context).textTheme.display2,
//            //),
////            Image.network(
////              "https://24tv.ua/resources/photos/news/201912/1243548_10326621.gif",
////              frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
////                return Padding(
////                  padding: EdgeInsets.all(28.0),
////                  child: child,
////                );
////              },
////              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
////                if (loadingProgress == null)
////                  return child;
////
////                return Center(
////                  child: CircularProgressIndicator(
////                    value: loadingProgress.expectedTotalBytes != null
////                        ? loadingProgress.cumulativeBytesLoaded /
////                        loadingProgress.expectedTotalBytes
////                        : null,
////                  ),
////                );
////              },
////            ),
//          ],
//        ),
      ),
    );
  }

  ListView listViewWidget(Response response) {
    List<PostItem> items = response.result;

    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: 250,
              color: Colors.amber[colorCodes[index % colorCodes.length]],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      items[index].description,
                    ),
                    Image.network(
                      items[index].gifURL,
                      frameBuilder: (BuildContext context, Widget child,
                          int frame, bool wasSynchronouslyLoaded) {
                        return Padding(
                          padding: EdgeInsets.all(28.0),
                          child: child,
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null)
                          return child;

                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ]
              )
          );
        }
    );
  }
}
