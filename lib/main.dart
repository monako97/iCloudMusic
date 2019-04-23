import 'package:flutter/material.dart';
import 'component/startPage.dart'; // 开始页面

void main() => runApp(ICloudMusic());

class ICloudMusic extends StatefulWidget {
  @override
  _ICloudMusicState createState() => _ICloudMusicState();
}

class _ICloudMusicState extends State<ICloudMusic> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ICloudMusic",
        debugShowCheckedModeBanner: false,
        home: StartPage());
  }
}
