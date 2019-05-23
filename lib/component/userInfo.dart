import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:icloudmusic/const/resource.dart';
import 'package:icloudmusic/utils/commotRequest.dart';

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
              image: AssetImage(M.UN),
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
                            EdgeInsets.only(top: D.topPadding + 80, bottom: 15.0),
                        child: Hero(
                          tag: 'USERINFO',
                          child: CircleAvatar(
                            backgroundImage: AssetImage(M.AURA_HOME),
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
                              fontFamily: 'SF-UI-Display-Regular'),
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
