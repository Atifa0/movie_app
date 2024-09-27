import 'package:flutter/material.dart';
import 'package:movie_app/Browse.dart';
import 'package:movie_app/Home_Screen.dart';
import 'package:movie_app/Search_Screen.dart';
import 'package:movie_app/Splash_Screen.dart';
import 'package:movie_app/WatchList.dart';

import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.RouteName,
      routes: {
        SplashScreen.RouteName: (context) => SplashScreen(),
        Home.RouteName: (context) => Home(),
        Home_Screen.RouteName: (context) => Home_Screen(),
        Search_Screen.RouteName: (context) => Search_Screen(),
        BrowseCategoryScreen.RouteName: (context) => BrowseCategoryScreen(),
        WatchList.RouteName: (context) => WatchList(),
      },
    );
  }
}
