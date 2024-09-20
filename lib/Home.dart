import 'package:flutter/material.dart';
import 'package:movie_app/Browse.dart';
import 'package:movie_app/Home_Screen.dart';
import 'package:movie_app/Search_Screen.dart';
import 'package:movie_app/WatchList.dart';

class Home extends StatefulWidget {
  static const String RouteName = 'Home_Screen';

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int selected_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Color(0xff1A1A1A),
        currentIndex: selected_index,
        onTap: (index) {
          setState(() {
            selected_index = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xffFFA90A),
        // Color of the selected item (icon and label)
        unselectedItemColor: Color(0xffC6C6C6),

        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(
                  'assets/images/Home.png',
                ),
                size: 45,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/Search.png'),
                size: 45,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/Browse.png'),
                size: 45,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/WatchList.png'),
                size: 45,
              ),
              label: "")
        ],
      ),
      body: buildPage(selected_index),
    );
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return Home_Screen(); // Page for the task list
      case 1:
        return Search_Screen(); // Page for settings
      case 2:
        return Browse(); // Page for settings
      case 3:
        return WatchList(); // Page for settings
      default:
        return Center(
            child: Text('')); // Default case in case of an unexpected index
    }
  }
}
