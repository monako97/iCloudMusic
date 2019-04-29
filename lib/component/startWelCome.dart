import 'package:flutter/material.dart';
import 'package:icloudmusic/component/logoStack.dart';

class StartWelCome extends StatefulWidget {
  @override
  _StartWelComeState createState() => _StartWelComeState();
}

class _StartWelComeState extends State<StartWelCome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: LogoStack(),
            ),
          ],
        ));
  }
}
