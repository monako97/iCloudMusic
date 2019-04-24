import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
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
