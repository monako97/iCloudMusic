import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'sqlite.dart';
import 'component/startPage.dart'; // 开始页面
import 'component/login.dart';
import 'component/registration.dart';
import 'component/drawer.dart';

void main() {
  runApp(ICloudMusic());
}
class ICloudMusic extends StatefulWidget {
  @override
  _ICloudMusicState createState() => _ICloudMusicState();
}

Map<String, dynamic> test = {
  'userId': '12221',
  'nickname': '张三',
  'avatarUrl': '头像数据',
  'birthday': '21212',
  'userType': '1',
  'djStatus': '21'
};
class _ICloudMusicState extends State<ICloudMusic> {
  final Sqlite = SqlLite();
  bool login;

  Future isLogin() async {
    // 开启数据表
    await Sqlite.open();
    await Sqlite.delUserInfo();
    return await Sqlite.queryUserInfo();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ICloudMusic",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/login": (context) {
          return Login();
        },
        "/registration": (context) {
          return Registration();
        },
      },
      home: FutureBuilder(
        future: isLogin(),
        builder: (context, snap) {
          print("数据：${snap.data}");
          if (snap.hasData) {
            if (snap.data.length > 0) {
              return DrawerPage();
            }

            return StartPage();
          }
          return Container(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
