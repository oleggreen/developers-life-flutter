import 'package:developerslife_flutter/localizations.dart';
import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:developerslife_flutter/main_screen/view_model/user_prefs_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget createOverflowMenu() => PopupMenuButton<MenuItem>(
    itemBuilder: (BuildContext context) => [
          popupMenuItem2(context),
        ]);

PopupMenuItem<MenuItem> popupMenuItem2(BuildContext context) {
  var userPrefs = Provider.of<UserPrefs>(context, listen: false);
  return PopupMenuItem(
      value: MenuItem.AUTO_LOAD_GIFS,
      child: CheckboxListTile(
        title: Text(DemoLocalizations.of(context).auto_load_gifs),
        value: userPrefs.loadGifUrlsPref,
        onChanged: (checked) {
          userPrefs.setLoadGifUrlsPref(checked);
          Provider.of<PostListModel>(context, listen: false).setAutoLoadGifs(checked);

          Navigator.pop(context, MenuItem.AUTO_LOAD_GIFS);
        },
      ));
}

enum MenuItem { AUTO_LOAD_GIFS }