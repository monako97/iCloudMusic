import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/Utils/commotRequest.dart';
import 'package:icloudmusic/const/resource.dart';
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("SETTINGS",
            style: TextStyle(
                fontFamily: F.SemiBold,
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
              child: Text("SETTINGS"),
            ),
            GestureDetector(
              onTap: (){
                H.loginOut(context);
              },
              child: Icon(CupertinoIcons.clear_thick_circled),
            )
          ],
        ),
      ),
    );
  }
}
