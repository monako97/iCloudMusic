import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'component/startPage.dart'; // 开始页面
import 'component/login.dart';
import 'component/registration.dart';
import 'component/startWelCome.dart';
import 'component/drawer.dart';

void main() => runApp(ICloudMusic());
class ICloudMusic extends StatefulWidget {
  @override
  _ICloudMusicState createState() => _ICloudMusicState();
}
class _ICloudMusicState extends State<ICloudMusic> {
  final Sqlite = SqlLite();

  whereTo() async {
    // 开启数据表
    await Sqlite.open();
    print(await Sqlite.queryLogin());

    return await Sqlite.queryLogin();
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
        "/drawer": (context) {
          return DrawerPage();
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
              return DrawerPage();
            }
            return StartPage();
          }
          return Container(color: Colors.white);
        },
      ),
    );
  }
}
