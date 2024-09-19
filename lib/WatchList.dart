import 'package:flutter/material.dart';

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  static const String RouteName = 'WatchList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WatchList'),
      ),
    );
  }
}
