import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/const/resource.dart';
class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("MY",
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
              child: Text("MY"),
            ),
            Icon(CupertinoIcons.music_note),
          ],
        ),
      ),
    );
  }
}
