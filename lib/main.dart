import 'package:developerslife_flutter/second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() => runApp(MyApp());

var greyColor = Color(0xff949494);
var lightGreyColor = Color(0xffcfcfcf);
var darkGreyColor = Color(0xff626262);

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
        initialRoute: '/',
        routes: {
          DetailsRoute.routeName: (context) => DetailsRoute(),
        },
        //ignore: missing_return
        onGenerateRoute: (settings) {
          if (settings.name == DetailsRoute.routeName) {
            // Cast the arguments to the correct type: ScreenArguments.
            final DetailsRouteArguments args = settings.arguments;

            // Then, extract the required data from the arguments and
            // pass the data to the correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return DetailsRoute(
//                  args.id
                );
              },
            );
          }
        }
    );
  }
}

