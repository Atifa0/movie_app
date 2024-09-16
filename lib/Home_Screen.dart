import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String RouteName = 'Home_Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }
}
