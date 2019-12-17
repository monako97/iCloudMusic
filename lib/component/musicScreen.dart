import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/widget/loading.dart';
class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  Widget build(BuildContext context) {
    Loading.context = context;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("MUSIC",
            style: TextStyle(
                fontFamily: "SF-UI-Display-Semibold",
                color: Color.fromRGBO(24, 29, 40, 1),
                fontSize: 18.0)),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
          border: null
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: DeviceInfo.padding+48),
              child: Text("MUSIC"),
            ),
            Icon(CupertinoIcons.music_note),
          ],
        ),
      )
    );
  }
}
