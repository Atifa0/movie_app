import 'package:flutter/material.dart';

import 'Home_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.RouteName,
      routes: {
        HomeScreen.RouteName: (context) => HomeScreen(),
      },
    );
  }
}
