import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
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
  final List<String> entries = <String>[
    "https://24tv.ua/resources/photos/news/201912/1243548_10326621.gif",
    "https://static.devli.ru/public/images/gifs/201907/d2dfb819-f081-4a2b-928a-e02859ac9daf.gif",
    "https://static.devli.ru/public/images/gifs/201303/65360af7-50cb-471a-8745-263ee1acd4f7.gif",
    "https://static.devli.ru/public/images/gifs/201303/84292b0d-2272-4109-bd4c-80f45f2914f5.gif",
    "https://static.devli.ru/public/images/gifs/201303/02926671-82c7-4cf5-a011-4440422458c9.gif",
    "https://static.devli.ru/public/images/gifs/201303/48c8de93-b846-4701-8254-536e3b1c7b2f.gif",
    "https://static.devli.ru/public/images/gifs/201303/c9f2e8b9-3cd9-4ffe-a5dc-5745b51865dc.gif",
    "https://static.devli.ru/public/images/gifs/201303/b39235fc-3154-4097-a394-dd74aecd4354.gif",
    "https://static.devli.ru/public/images/gifs/201304/be5f82f1-3af8-44c0-90d3-bbe2027462c3.gif",
    "https://static.devli.ru/public/images/gifs/201304/b4447fc6-4fcf-4bec-a502-3ebe025a4367.gif",
    "https://static.devli.ru/public/images/gifs/201303/a5ae9741-c257-41dd-837d-a744ebc1fc64.gif",
    "https://static.devli.ru/public/images/gifs/201303/313d3f40-66ea-4eca-9252-b8f2fe2ae88c.gif",
    "https://static.devli.ru/public/images/gifs/201303/b8ad9589-f292-4a9a-87ab-0bb73dc09435.gif",
    "https://static.devli.ru/public/images/gifs/201304/cf94ce5f-ab59-4858-b447-9e5c8e5dbd2c.gif",
    "https://static.devli.ru/public/images/gifs/201303/1f336fe5-35b2-47fd-8a9d-6cb98314ea76.gif"
  ];
  final List<int> colorCodes = <int>[600, 500, 100];

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
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 250,
                  color: Colors.amber[colorCodes[index % colorCodes.length]],
                  child: Image.network(
                    entries[index],
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
              );
            }
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add_call),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
