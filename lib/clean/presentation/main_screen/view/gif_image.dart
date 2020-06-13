import 'package:developerslife_flutter/clean/presentation/main_screen/view_model/post_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GifImageWidget extends StatefulWidget {
  @override
  _GifImageWidgetState createState() => _GifImageWidgetState();

  static Image buildGifImageItself(String gifUrl) {
    return Image.network(
      gifUrl,
      height: 276,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null)
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: child,
          );

        return Container(
          height: 280,
          width: double.infinity,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(color: Colors.transparent),
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
  }
}

class _GifImageWidgetState extends State<GifImageWidget> {
  bool pressed = false;

  _GifImageWidgetState();

  @override
  Widget build(BuildContext context) {
    return Consumer<PostItemModel>(
      builder: (context, postItemModel, _) {
        return GestureDetector(
          onTap: () {
            print("GifImageWidget: onTap");
            postItemModel.toggle();
          },
          child: Listener(
            onPointerDown: (event) => setState(() {
              print("GifImageWidget: onPointerDown");
              pressed = true;
            }),
            onPointerCancel: (event) => setState(() {
              print("GifImageWidget: onPointerCancel");
              pressed = false;
            }),
            onPointerUp: (event) => setState(() {
              print("GifImageWidget: onPointerUp");
              pressed = false;
            }),
            child: Column(
              children: [
                loadGifOrEmpty(postItemModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loadGifOrEmpty(PostItemModel postItemModel) {
    if (postItemModel.activated) {
      return GifImageWidget.buildGifImageItself(postItemModel.postItem.gifURL);
    } else {
      return Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        alignment: Alignment.center,
        child: Container(
          height: 180,
          width: 180,
          padding: EdgeInsets.all(20),
          decoration: ShapeDecoration(color: pressed ? Color(0x99000000) : Color(0x77000000), shape: CircleBorder()),
          child: LayoutBuilder(builder: (context, constraint) {
            return Icon(Icons.play_arrow,
                color: pressed ? Colors.white : Color(0x77ffffff), size: constraint.biggest.height);
          }),
        ),
      );
    }
  }
}