import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/component/homeScreen.dart';
import 'package:icloudmusic/component/musicScreen.dart';
import 'package:icloudmusic/component/personScreen.dart';
import 'package:icloudmusic/component/settings.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'dart:ui';
class BottomNavigationTabBarScreen extends StatefulWidget {
  @override
  _BottomNavigationTabBarScreenState createState() =>
      _BottomNavigationTabBarScreenState();
}

class _BottomNavigationTabBarScreenState
    extends State<BottomNavigationTabBarScreen> {
  int _currentIndex = 0;
  List<Widget> _pageScreen = List();
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

  @override
  Widget build(BuildContext context) {
    return _materialScaffold();
  }
  Widget _materialScaffold()=> Scaffold(
    body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: _pageScreen,
        onPageChanged: _pageChange
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.music_note),
      backgroundColor: Colors.red,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    bottomNavigationBar: _bubbleNavigationBar(),
    resizeToAvoidBottomPadding: false,
    resizeToAvoidBottomInset: false,
  );
  Widget _bubbleNavigationBar() => BubbleBottomBar(
    hasNotch: true,
    fabLocation: BubbleBottomBarFabLocation.end,
    opacity: 0.2,
    currentIndex: _currentIndex,
    onTap: onTap,
    borderRadius: BorderRadius.vertical(
        top: Radius.circular(
            16)),
    elevation: 1,
    items: <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.home,
            color: C.DEF,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Colors.red,
          ),
          title: Text(
            "HOME",
            style: TextStyle(fontFamily: F.Medium),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.indigo,
          icon: Icon(Icons.music_note, color: C.DEF),
          activeIcon: Icon(
            Icons.music_note,
            color: Colors.indigo,
          ),
          title: Text(
            "MUSIC",
            style: TextStyle(fontFamily: F.Medium),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.green,
          icon: Icon(Icons.person, color: C.DEF),
          activeIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          title: Text(
            "MY",
            style: TextStyle(fontFamily: F.Medium),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.deepPurple,
          icon: Icon(
            Icons.settings,
            color: C.DEF,
          ),
          activeIcon: Icon(
            Icons.settings,
            color: Colors.deepPurple,
          ),
          title: Text(
            "SETTING",
            style: TextStyle(fontFamily: F.Medium),
          )),
    ],
  );
  void onTap(int index) {
    this._currentIndex = index;
    setState(() {});
    _pageController.animateToPage(index,
        duration: const Duration(microseconds: 1), curve: Curves.ease);
  }
  void _pageChange(int index) {
    setState(() {
      if (_currentIndex != index) {
        _currentIndex = index;
      }
    });
  }
}
