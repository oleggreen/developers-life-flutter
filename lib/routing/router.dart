import 'package:developerslife_flutter/extensions/string_extensions.dart';
import 'package:developerslife_flutter/main_screen/view/home_screen.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';
import 'package:developerslife_flutter/second_screen.dart';
import 'package:developerslife_flutter/routing/screens/view_404.dart';
import 'package:flutter/material.dart';

const String homeRoute = '/';
//const String detailsRoute = '/detailsRandom';
const String detailIdRoute = '/details';

Route<dynamic> generateRoute(RouteSettings settings) {
  var postItem = PostItem(
      id: 9993,
      description: "Выцепил свой первый коммит из истории.",
      votes: -9,
      author: "vitya",
      date: "Mar 19, 2014 4:53:18 PM",
      gifURL: "http://static.devli.ru/public/images/gifs/201403/821f2338-0908-4c3a-a928-f6b3d0e0a1d1.gif",
      gifSize: 1884193,
      previewURL: "https://static.devli.ru/public/images/previews/201403/aadb74b0-8888-49ad-88ef-bac0ffe998f2.jpg",
      type: AnimationType.GIF
  );

  var routingData = getRoutingData(settings.name);

  print("Routing data: " + routingData.toString());

  switch (routingData.route) {
    case homeRoute:
      return _getPageRoute(MyHomePage(), settings);
//      return MaterialPageRoute(builder: (context) => MyHomePage());

//    case detailsRoute:
//      return _getPageRoute(SecondRoute(postItem.id, postItem), settings);

    case detailIdRoute:
      var id = int.tryParse(routingData['id']);
      return _getPageRoute(SecondRoute(id, null), settings);

    default:
      return MaterialPageRoute(builder: (context) => UndefinedView(name: settings.name,));
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({this.child, this.routeName}): super(settings: RouteSettings(name: routeName),pageBuilder: (BuildContext context,Animation<double> animation, Animation<double> secondaryAnimation,) =>
    child,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}