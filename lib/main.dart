import 'package:developerslife_flutter/main_screen/view_model/post_list_model.dart';
import 'package:developerslife_flutter/main_screen/view_model/selected_category_model.dart';
import 'package:developerslife_flutter/main_screen/view_model/user_prefs_model.dart';
import 'package:developerslife_flutter/routing/navigation_service.dart';
import 'package:developerslife_flutter/routing/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'main_screen/view/home_screen.dart';
import 'package:developerslife_flutter/generated/l10n.dart';

void main() {
  runApp(MyApp());
}

var greyColor = Color(0xff949494);
var lightGreyColor = Color(0xffcfcfcf);
var darkGreyColor = Color(0xff626262);

MaterialLocalizations of(BuildContext context) {
  return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

var navigationService = NavigationService();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: "Developers Lite",
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
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => PostListModel(),
            ),
            ChangeNotifierProvider(
              create: (_) => SelectedCategory(),
            ),
            ChangeNotifierProvider(
              create: (_) => UserPrefs(),
            ),
          ],
          child: MyHomePage(title: "Developers Lite")),

      initialRoute: homeRoute,
      navigatorKey: navigationService.navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
