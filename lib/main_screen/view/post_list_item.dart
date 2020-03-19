import 'package:cached_network_image/cached_network_image.dart';
import 'package:developerslife_flutter/main.dart';
import 'package:developerslife_flutter/main_screen/view/gif_image.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';
import 'package:developerslife_flutter/routing/router.dart';
import 'package:developerslife_flutter/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:developerslife_flutter/generated/l10n.dart';

import 'package:share/share.dart';

//TODO refactor
class PostListWidgetBuilder {
  static Widget buildListItemWidget(BuildContext context, PostItem postItem, ThemeData curTheme) {
    return
      Card(
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
                              child: Image(
                                image: CachedNetworkImageProvider(postItem.previewURL),
                                height: 276,
                                frameBuilder:
                                    (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                                  return Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: child,
                                  );
                                },
                              )),
                          GifImageWidget(),
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
                              buildPostInfoWidget(context, postItem, curTheme),
                              buildSharePostLinkButton(curTheme, postItem),
                              buildShareGifLinkButton(curTheme, postItem),
                              buildOpenDetailsButton(context, curTheme, postItem),
                            ])),
                  ])));
  }

  static Widget buildPostInfoWidget(BuildContext context, PostItem postItem, ThemeData curTheme) {
    var votesCount = postItem.votes;
    return Expanded(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).authorLabel + postItem.author,
              softWrap: false,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: greyColor),
            ),
            Row(
              children: <Widget>[
                Text(
                  S.of(context).ratingLabel + votesCount.toString(),
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
    );
  }

  static Widget buildSharePostLinkButton(ThemeData curTheme, PostItem postItem) {
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

  static Widget buildShareGifLinkButton(ThemeData curTheme, PostItem postItem) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return Container(
        decoration: BoxDecoration(
            color: curTheme.primaryColor),
        padding: EdgeInsets.only(top: 2, bottom: 2, left: 1, right: 0),
        child: ButtonTheme(
          minWidth: 20.0,
          height: 10.0,
          child: FlatButton(
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

  static Widget buildOpenDetailsButton(BuildContext context, ThemeData curTheme, PostItem postItem) {
    return Container(
      decoration: BoxDecoration(
          color: curTheme.primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(7))),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
      child: ButtonTheme(
        minWidth: 20.0,
        height: 10.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
          ),
          child: Icon(Icons.open_in_new, color: curTheme.primaryColor),
          onPressed: () {
            if (kIsWeb) {
              navigationService.navigateTo(detailIdRoute, queryParams: {'id': postItem.id.toString()});
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute(postItem.id, postItem)));
            }
          },
          color: curTheme.primaryColorLight,
          textColor: Colors.white,
          splashColor: Colors.white,
        ),
      ),
    );
  }
}