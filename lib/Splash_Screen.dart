import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/Home_Screen.dart';

class SplashScreen extends StatefulWidget {
  static const String RouteName = 'Splash_Screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset('assets/images/splash_screen.png'),
    );
  }
}
