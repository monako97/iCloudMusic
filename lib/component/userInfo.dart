import 'package:flutter/material.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'dart:ui';
class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  double _radius = 30.0;

  @override
  void initState() {
    Future<Duration>.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _radius = 30.0;
      });
      return Duration(milliseconds: 210);
    }).then((Duration d) {
      Future<Duration>.delayed(d, () {
        setState(() {
          _radius = 50.0;
        });
        return Duration(milliseconds: 210);
      }).then((Duration d) {
        // ignore: missing_return
        Future<Duration>.delayed(d, () {
          setState(() {
            _radius = 45.0;
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/0.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: DeviceInfo.padding + 80, bottom: 15.0),
                        child: Hero(
                          tag: 'USERINFO',
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/images/aura_home.png"),
                            backgroundColor: Colors.white,
                            radius: _radius,
                          ),
                        ),
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("USERNAME",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: "SF-UI-Display-Regular"),
                        ),
                        Image.asset(
                          1 == 1
                              ? 'assets/images/boy.png'
                              : 'assets/images/girl.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}
