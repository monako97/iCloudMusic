import 'package:flutter/material.dart';
import 'package:icloudmusic/component/home/homeScreen.dart';
import 'package:icloudmusic/component/musicScreen.dart';
import 'package:icloudmusic/component/personScreen.dart';
import 'package:icloudmusic/component/settings.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:icloudmusic/widget/loading.dart';
class BottomNavigationTabBarScreen extends StatefulWidget {
  @override
  _BottomNavigationTabBarScreenState createState() =>
      _BottomNavigationTabBarScreenState();
}

class _BottomNavigationTabBarScreenState
    extends State<BottomNavigationTabBarScreen> {
  int _currentIndex = 0;
  final List<Widget> _pageScreen = List();
  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    _pageScreen
      ..add(HomeScreen())
      ..add(MusicScreen())
      ..add(PersonScreen())
      ..add(SettingsScreen());
    super.initState();
  }
  void onTap(int index) {
    setState(() {
      if (_currentIndex != index) {
        this._currentIndex = index;
      }
    });
    _pageController.animateToPage(index,
        duration: Duration(microseconds: 300), curve: Curves.ease);
  }
  void _pageChange(int ide) {
    setState(() {
      if (_currentIndex != ide) {
        this._currentIndex = ide;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          children: _pageScreen,
          onPageChanged: _pageChange
      ),
      bottomNavigationBar: BubbleBottomBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        opacity: 0.2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 7,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(Icons.home,color: Color.fromRGBO(24, 29, 40, 0.87)),
              activeIcon: Icon(Icons.home),
              title: Text(
                "HOME",
                style: TextStyle(fontFamily: "SF-UI-Display-Regular"),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(Icons.music_note,color: Color.fromRGBO(24, 29, 40, 0.87)),
              activeIcon: Icon(Icons.music_note),
              title: Text(
                "MUSIC",
                style: TextStyle(fontFamily: "SF-UI-Display-Regular"),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.person,color: Color.fromRGBO(24, 29, 40, 0.87)),
              activeIcon: Icon(Icons.person),
              title: Text(
                "MY",
                style: TextStyle(fontFamily: "SF-UI-Display-Regular"),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(Icons.settings,color: Color.fromRGBO(24, 29, 40, 0.87)),
              activeIcon: Icon(Icons.settings),
              title: Text(
                "SETTING",
                style: TextStyle(fontFamily: "SF-UI-Display-Regular"),
              )),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
    );
  }
}