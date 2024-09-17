import 'package:flutter/material.dart';
import 'package:movie_app/Splash_Screen.dart';

import 'Home_Screen.dart';

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
        HomeScreen.RouteName: (context) => HomeScreen(),
      },
    );
  }
}
