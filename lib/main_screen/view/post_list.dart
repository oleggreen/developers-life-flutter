import 'package:developerslife_flutter/generated/l10n.dart';
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
        const listPadding = 8.0;
        var heightConstraint = constraints.maxHeight - listPadding * 2;
        var widthConstraint = constraints.maxWidth - listPadding * 2;

        return ListView.separated(
            padding: const EdgeInsets.all(listPadding),
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
                    return buildErrorLoadWidget(context, heightConstraint, widthConstraint);
                  } else {
                    return buildEmptyStateWidget(context, heightConstraint, widthConstraint);
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

  SizedBox buildEmptyStateWidget(BuildContext context, double heightConstraint, double widthConstraint) =>
      SizedBox(height: heightConstraint,
        width: widthConstraint,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.free_breakfast,
                  size: 150,
                  color: Colors.orange,
                ),
                Container(
                  height: 20,
                ),
                Text(
                  S.of(context).emptyStateMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 20,
                ),
                Text(
                  S.of(context).emptyStateDetails,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );

  SizedBox buildErrorLoadWidget(BuildContext context, double heightConstraint, double widthConstraint) =>
      SizedBox(height: heightConstraint,
        width: widthConstraint,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 150,
                  color: Colors.red,
                ),
                Container(
                  height: 20,
                ),
                Text(
                  S.of(context).failToLoadDataMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 20,
                ),
                Text(
                  S.of(context).failToLoadDataRecommendation,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
}
