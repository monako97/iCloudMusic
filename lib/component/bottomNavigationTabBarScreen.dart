import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/component/homeScreen.dart';
import 'package:icloudmusic/component/musicScreen.dart';
import 'package:icloudmusic/component/personScreen.dart';
import 'package:icloudmusic/component/settings.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
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
    bottomNavigationBar: _bottomNavigationBar(),
    resizeToAvoidBottomPadding: false,
    resizeToAvoidBottomInset: false,
  );
  Widget _bottomNavigationBar() => BubbleBottomBar(
    currentIndex: _currentIndex,
    onTap: onTap,
    opacity: 0.2,
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    elevation: 7,
    items: <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: Colors.red,
          icon: Icon(Icons.home,color: C.DEFT),
          activeIcon: Icon(Icons.home),
          title: Text(
            "HOME",
            style: TextStyle(fontFamily: F.Regular),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.indigo,
          icon: Icon(Icons.music_note,color: C.DEFT),
          activeIcon: Icon(Icons.music_note),
          title: Text(
            "MUSIC",
            style: TextStyle(fontFamily: F.Regular),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.green,
          icon: Icon(Icons.person,color: C.DEFT),
          activeIcon: Icon(Icons.person),
          title: Text(
            "MY",
            style: TextStyle(fontFamily: F.Regular),
          )),
      BubbleBottomBarItem(
          backgroundColor: Colors.deepPurple,
          icon: Icon(Icons.settings,color: C.DEFT),
          activeIcon: Icon(Icons.settings),
          title: Text(
            "SETTING",
            style: TextStyle(fontFamily: F.Regular),
          )),
    ],
  );
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
}