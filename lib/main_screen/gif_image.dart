import 'package:developerslife_flutter/main_screen/user_prefs.dart';
import 'package:developerslife_flutter/network/model/PostItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Consumer<UserPrefs>(
      builder: (context, userPrefs, _) {
        print("UserPrefs: Consumer().builder $loadGif");
        if (!userRequested) {
          loadGif = userPrefs.loadGifUrlsPref;
          print("UserPrefs: Consumer().builder overriden: $loadGif");
        }
        return Listener(
          onPointerDown: (event) => setState(() {
            pressed = !pressed;
          }),
          onPointerCancel: (event) => setState(() {
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
          return Icon(Icons.play_arrow,
              color: pressed ? Colors.white : Color(0x77ffffff), size: constraint.biggest.height);
        }),
      );
    }
  }
}