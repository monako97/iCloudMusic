import 'package:flutter/material.dart';
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final SqlLites = SqlLite();

  void LogOut() async {
    Map<String, dynamic> result = await HttpUtils.request(
        '/logout', method: HttpUtils.GET);
    if (result['code'] == 200) {
      await SqlLites.open();
      await SqlLites.delLoginInfo();
      Navigator.pushNamedAndRemoveUntil(
          context, '/start', (route) => route == null);
    } else {
      print("退出失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("home"),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xfff1f2f3),
          child: new Column(
            children: <Widget>[
              new Image.asset('assets/images/splash.png'),
              new Container(
                padding: new EdgeInsets.all(20.0),
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.home, color: Colors.black87),
                    new Text('首页'),
                    new RaisedButton(
                      onPressed: LogOut,
                      child: Text("退出"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
