import 'package:flutter/material.dart';

class Home_Screen extends StatelessWidget {
  const Home_Screen({super.key});
  static const String RouteName = 'Home_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home_Screen'),
      ),
    );
  }
}
