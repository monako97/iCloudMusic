import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("MUSIC",
            style: TextStyle(
                fontFamily: F.Semibold,
                color: C.DEF,
                fontSize: 18.0)),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
          border: null
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: D.topPadding+48),
              child: Text("飒飒差"),
            ),
            Icon(CupertinoIcons.music_note),
          ],
        ),
      )
    );
  }
}
