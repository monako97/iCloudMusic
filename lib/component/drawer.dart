import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/component/settings.dart';
import 'package:icloudmusic/component/homeScreen.dart';
import 'package:icloudmusic/component/userInfo.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';

// 获取状态栏高度
double topPadding = MediaQueryData
    .fromWindow(window)
    .padding
    .top;
class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  DrawerScaffoldController _drawerController;
  bool isShowAppBar = true;
  final sqlLites = SqlLite();
  String _avatarUrl; // 头像
  String _userName; // 用户名
  int _gender; // 性别
  int _userId;
  String _backgroundUrl; // 背景
  var selectedMenuItemId = 'home'; //默认显示的页面
  bool searchChecked = false;

  Widget headerView(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: <Widget>[
          Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _avatarUrl == null ? AssetImage(
                        M.UN) : NetworkImage(_avatarUrl),
                  )
              )
          ),
          Container(
              margin: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _userName == null ? '' : _userName,
                    style: TextStyle(
                        color: C.DEF,
                        fontSize: 18.0,
                        fontFamily: F.Regular
                    ),
                  ),
                  Text(
                    "个人简介",
                    style: TextStyle(
                        color: C.DEF,
                        fontSize: 13.0,
                        fontFamily: F.Regular
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void logOut() async {
    var result = await HttpUtils.request(
        '/logout', method: HttpUtils.POST);
    if (result['code'] == 200) {
      await sqlLites.open();
      await sqlLites.delLoginInfo();
      Navigator.pushNamedAndRemoveUntil(
          context, '/start', (route) => route == null);
    } else {
      print("退出失败");
    }
  }

  @override
  void initState() {
    (() async {
      await sqlLites.open();
      var userInfo = await sqlLites.queryUserInfo();
      setState(() {
        _avatarUrl = userInfo[0]['avatarUrl'];
        _userName = userInfo[0]['nickname'];
        _gender = userInfo[0]['gender'];
        _backgroundUrl = userInfo[0]['backgroundUrl'];
        _userId = userInfo[0]['userId'];
      });
    })();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      percentage: 0.75,
      cornerRadius: 20,
      controller: _drawerController,
      contentShadow: C.CD_SHADOW,
      showAppBar: isShowAppBar,
      appBar: AppBarProps(
        flexibleSpace: Container(
          width: 60.0,
          height: 60.0,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: topPadding),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, FadeRoute(
                  (UserInfoScreen(avatarUrl: _avatarUrl,
                      username: _userName,
                      gender: _gender,
                      backgroundUrl: _backgroundUrl,
                      userId: _userId))));
            },
            child: Hero(
                tag: 'USERINFO',
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: _avatarUrl == null ? AssetImage(
                      M.UN) : NetworkImage(_avatarUrl),
                )
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              this.searchChecked = !(this.searchChecked ?? false);
              setState(() {});
            },
            child: Container(
              width: 50,
              alignment: Alignment.centerRight,
              child: FlareActor(
                R.ASSET_MSG_FLR,
                animation: this.searchChecked ? "Notification Loop" : "",
                isPaused: this.searchChecked,
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: C.DEF
        ),
      ),
      menuView: MenuView(
        menu: menu,
        headerView: headerView(context),
        animation: false,
        footerView: IconButton(
          onPressed: logOut,
          color: Colors.pink,
          iconSize: 28,
          splashColor: Colors.pink[200],
          icon: Icon(Icons.exit_to_app),
        ),
        background: DecorationImage(
          image: _backgroundUrl == null
              ? AssetImage(M.UN)
              : NetworkImage(_backgroundUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
        selectorColor: Colors.pinkAccent,
        textStyle: TextStyle(
            color: C.DEF,
            fontSize: 18.0,
            fontFamily: F.Regular
        ),
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          if (itemId == 'settings') {
            isShowAppBar = false;
          } else {
            isShowAppBar = true;
          }
          setState(() {
            selectedMenuItemId = itemId;
          });
        },
      ),
      contentView: Screen(
        contentBuilder: (context) {
          switch (selectedMenuItemId) {
            case 'home':
              return HomeScreen();
              break;
            case 'settings':
              return SettingsScreen();
              break;
          }
        },
        color: Colors.white,
      ),
    );
  }
}

final menu = Menu(
  items: [
    MenuItem(
        id: 'home',
        title: 'HOME',
        icon: Icons.home
    ),
    MenuItem(
        id: 'settings',
        title: 'SETTINGS',
        icon: Icons.settings
    ),
    MenuItem(
        id: 'share',
        title: 'Share',
        icon: Icons.share
    ),
  ],
);
