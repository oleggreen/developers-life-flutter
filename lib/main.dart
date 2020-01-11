import 'package:developerslife_flutter/main_screen/selected_category.dart';
import 'package:developerslife_flutter/second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'main_screen/home_screen.dart';
import 'localizations.dart';
import 'main_screen/user_prefs.dart';

void main() {
  runApp(MyApp());
}

var greyColor = Color(0xff949494);
var lightGreyColor = Color(0xffcfcfcf);
var darkGreyColor = Color(0xff626262);

MaterialLocalizations of(BuildContext context) {
return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserPrefs(),
          ),
          ChangeNotifierProvider(
            create: (_) => SelectedCategory(),
          ),
        ],
        child: MaterialApp(
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              const DemoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale('uk'), // Ukrainian
            ],
            title: 'Flutter Demo',
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
            home: MyHomePage(title: 'Developers Lite'),
            initialRoute: '/',
            routes: {
              DetailsRoute.routeName: (context) => DetailsRoute(),
            },
            //ignore: missing_return
            onGenerateRoute: (settings) {
              if (settings.name == DetailsRoute.routeName) {
                // Cast the arguments to the correct type: ScreenArguments.
//                final DetailsRouteArguments args = settings.arguments;

                // Then, extract the required data from the arguments and
                // pass the data to the correct screen.
                return MaterialPageRoute(
                  builder: (context) {
                    return DetailsRoute();
                    },
                );
              }
            }
        )
    );
  }
}

