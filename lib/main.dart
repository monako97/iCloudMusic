import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
import 'package:icloudmusic/component/startPage.dart'; // 开始页面
import 'package:icloudmusic/component/login/login.dart';
import 'package:icloudmusic/component/registration/registration.dart';
import 'package:icloudmusic/component/welCome/startWelCome.dart';
import 'package:icloudmusic/component/bottomNavigationTabBarScreen.dart';
void main() => runApp(ICloudMusic());
class ICloudMusic extends StatefulWidget {
  @override
  _ICloudMusicState createState() => _ICloudMusicState();
}
class _ICloudMusicState extends State<ICloudMusic> {
  final _sqLite = SqlLite();
  whereTo() async {
    // 开启数据表
    await _sqLite.open();
    return await _sqLite.queryLogin();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ICloudMusic",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/start": (context) {
          return StartPage();
        },
        "/startWelcome": (context) {
          return StartWelCome();
        },
        "/login": (context) {
          return Login();
        },
        "/registration": (context) {
          return Registration();
        },
        "/main": (context) {
          return BottomNavigationTabBarScreen();
        },
      },
      home: FutureBuilder(
        future: whereTo(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data.length > 0 && snap.data[0]['login'] == 1) {
              if (snap.data[0]['first'] == 1) { // 首次使用状态
                return StartWelCome();
              }
              return BottomNavigationTabBarScreen();
            }
            return StartPage();
          }
          return Container(color: Colors.white);
        },
      ),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          platform: TargetPlatform.iOS //右滑返回
      ),
    );
  }
}
