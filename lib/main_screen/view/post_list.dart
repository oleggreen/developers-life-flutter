import 'package:developerslife_flutter/main_screen/view/post_list_item.dart';
import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostListModel>(builder: (context, postListModel, _) {
      if (postListModel.items.isEmpty && postListModel.state == PostListState.LOADING) {
        return Center(child: CircularProgressIndicator());
      } else {
        return RefreshIndicator(
          onRefresh: () => postListModel.reLoadCurrentCategory(),
          child: createList(postListModel),
        );
      }
    });
  }

  Widget createList(PostListModel postListModel) {
    return NotificationListener<ScrollNotification>(
      // ignore: missing_return
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 500 && !postListModel.isAllItemsLoaded()) {
          postListModel.loadMore();
        }
      },

      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: postListModel.items.length + 1,
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 2,
                  color: Colors.transparent,
                ),
            itemBuilder: (BuildContext context, int index) {
              if (index == postListModel.items.length) {
                if (postListModel.items.length == 0) {
                  if (postListModel.state == PostListState.ERROR) {
                    return SizedBox(
                        height: constraints.maxHeight, width: constraints.maxWidth, child: Center(child: Text("Some error occured.TODO")));
                  } else {
                    return SizedBox(height: constraints.maxHeight, width: constraints.maxWidth, child: Center(child: Text("Empty state.TODO")));
                  }
                } else if (postListModel.isAllItemsLoaded()) {
                  return Center(child: Text("The end"));
                } else {
                  return Center(child: CircularProgressIndicator(backgroundColor: Colors.black));
                }
              } else {
                var curTheme = Theme.of(context);
                var postItem = postListModel.items[index];

                return ChangeNotifierProvider.value(
                    value: postItem, child: PostListWidgetBuilder.buildListItemWidget(context, postItem.postItem, curTheme));
              }
            });
      }),
    );
  }
}