import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GifImageWidget extends StatefulWidget {
  @override
  _GifImageWidgetState createState() => _GifImageWidgetState();
}

class _GifImageWidgetState extends State<GifImageWidget> {
  bool pressed = false;

  _GifImageWidgetState();

  @override
  Widget build(BuildContext context) {
    return Consumer<PostItemModel>(
      builder: (context, postItemModel, _) {
        return Listener(
          onPointerDown: (event) => setState(() {
            pressed = !pressed;
          }),
          onPointerCancel: (event) => setState(() {
            pressed = false;
          }),
          onPointerUp: (event) {
            print("UserPrefs: onPointerUp");
            postItemModel.toggle();
            pressed = false;
            setState(() => {});
          },
          child: Column(
            children: [
              loadGifOrEmpty(postItemModel),
            ],
          ),
        );
      },
    );
  }

  Widget loadGifOrEmpty(PostItemModel postItemModel) {
    if (postItemModel.activated) {
      return Image.network(
        postItemModel.postItem.gifURL,
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