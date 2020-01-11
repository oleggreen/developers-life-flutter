import 'dart:convert';

import 'package:flutter/material.dart';

import 'main.dart';
import 'network/model/PostItem.dart';

class SecondRoute extends StatelessWidget {

  final PostItem postItem;

  SecondRoute(this.postItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          brightness: Brightness.dark,
          title: Text("Post: " + postItem.id.toString(), style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                postItem.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    color: darkGreyColor
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                    tag: postItem.previewURL,
                    child: Image.network(
                      postItem.previewURL,
                      frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                        return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: child,
                        );
                      },
                    )),
              )

            ],
          ),
        ));
  }
}

class DetailsRouteArguments {
  final int id;

  DetailsRouteArguments(this.id);
}

//http://localhost:52083/#/post
class DetailsRoute extends StatelessWidget {
  static const routeName = '/post';

  final String postItemJson = "{\"id\": 132, \"description\": \"Когда тестировщик не может понять, баг это или фича\", \"votes\": 1173, \"author\": \"Aleksandr\", \"date\": \"Mar 19, 2013 7:14:00 AM\", \"gifURL\": \"http://static.devli.ru/public/images/gifs/201303/52b6b0ae-6e7e-431b-9705-849b42c9a433.gif\", \"gifSize\": 1045535, \"previewURL\": \"https://static.devli.ru/public/images/previews/201303/156c3f58-7ea6-4c5c-b6ad-ca143e52e9ec.jpg\", \"videoURL\": \"http://static.devli.ru/public/images/v/201303/0e376632-efe4-4139-a7ca-86ea2bfdcc67.mp4\", \"videoPath\": \"/public/images/v/201303/0e376632-efe4-4139-a7ca-86ea2bfdcc67.mp4\", \"videoSize\": 615375, \"type\": \"gif\", \"width\": \"196\", \"height\": \"165\", \"commentsCount\": 0, \"fileSize\": 1045535, \"canVote\": false }";

  @override
  Widget build(BuildContext context) {
    final PostItem postItem = PostItem.fromJsonMap(json.decode(postItemJson));

    final DetailsRouteArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          brightness: Brightness.dark,
          title: Text("Post: " + postItem.id.toString(), style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                postItem.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    color: darkGreyColor
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: postItem.gifURL,
                    child: Image.network(
                      postItem.gifURL,
                      frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                        return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: child,
                        );
                      },
                    )),
              )

            ],
          ),
        ));
  }
}