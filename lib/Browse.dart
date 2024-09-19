import 'package:flutter/material.dart';

class Browse extends StatelessWidget {
  const Browse({super.key});

  static const String RouteName = 'Browse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse'),
      ),
    );
  }
}
