import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:icloudmusic/component/animateCard.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/Utils/commotRequest.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'dart:ui';

import 'package:icloudmusic/widget/loading.dart';
class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}
class _PersonScreenState extends State<PersonScreen> with AutomaticKeepAliveClientMixin {
  double _radius = 30.0;
  // 屏幕高度
  @override
  void initState() {
    super.initState();
    (()async{
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
      await H.getSubCount();
    })();
  }
  @override
  void dispose() {
    super.dispose();
  }
  Widget build(BuildContext context) {
    super.build(context);
    Loading.context = context;
    return Scaffold(
      body: FutureBuilder(
        future: H.getUserDetail(),
        builder: (context,snap){
          return Stack(
            children: <Widget>[
              ClipRect(
                child: Container(
                  height: DeviceInfo.width,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      image: DecorationImage(
                          image: snap.hasData&&snap.data['code']==200 ?
                          NetworkImage(snap.data['profile']['backgroundUrl']) :
                          AssetImage("assets/images/0.png"),
                          fit: BoxFit.cover
                      )
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                        alignment: Alignment.center,
                        color: Color.fromRGBO(0, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              EasyRefresh(
                header: BallPulseHeader(
                  color: Colors.redAccent.shade200,
                ),
                // ignore: missing_return
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2), () {
                    setState(() {});
                  });
                },
                child: ListView(
                  padding: EdgeInsets.only(top: DeviceInfo.padding + 48.0),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    // 顶部栏
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: ClipPath(
                            clipper: TopBarClipper(
                                MediaQuery.of(context).size.width, 200.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200.0,
                              child: Container(
                                  width: double.infinity,
                                  height: 240.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        // 名字
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snap.hasData&&snap.data['code']==200 ? snap.data['profile']['nickname'] : "PLEASE LOGIN",
                                style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontFamily: "SF-UI-Display-Regular"
                                ),
                              ),
                              snap.hasData&&snap.data['code']==200 ? Image.asset(
                                  "assets/images/boy.png",
                                  width: 25.0,
                                  height: 25.0
                              ):Container(),
                            ],
                          ),
                        ),
                        // 图标
                        Container(
                            height: 100.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 100.0),
                            child: CircleAvatar(
                              backgroundImage: snap.hasData&&snap.data['code']==200 ?
                              NetworkImage(snap.data['profile']['avatarUrl']) :
                              AssetImage("assets/images/0.png"),
                              backgroundColor: Colors.redAccent.shade200,
                              radius: _radius,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2
                                    )
                                ),
                                child: snap.hasData&&snap.data['code']==200 ? null : Icon(Icons.person,color: Colors.white,size: 50),
                              ),
                            )
                        ),
                      ],
                    ),
                    // 内容
                    personContext()
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
// 内容
Widget personContext()=> Container(
    color: Colors.white,
    padding: EdgeInsets.all(20.0),
    child: FutureBuilder(
      future: H.getSubCount(),
      builder: (BuildContext context,AsyncSnapshot snapSub){
        return Wrap(
          runSpacing:  DeviceInfo.height < 570 ? (DeviceInfo.width-300)/2 : 20.0,
          spacing: DeviceInfo.height < 570 ? (DeviceInfo.width-300)/2 : 20.0,
          alignment: WrapAlignment.center,
          children: <Widget>[
            AnimateCard(title: 'COLLECTOR',number: snapSub.hasData&&snapSub.data['code']==200?snapSub.data['subPlaylistCount']:0,color: Color.fromRGBO(233, 136, 124, 1.00)),
            AnimateCard(title: 'SONG',number: snapSub.hasData&&snapSub.data['code']==200?snapSub.data['createdPlaylistCount']:0,color: Color.fromRGBO(209, 231, 166, 1.00)),
            AnimateCard(title: 'ARTIST',number: snapSub.hasData&&snapSub.data['code']==200?snapSub.data['createdPlaylistCount']:0,color: Color.fromRGBO(245, 221, 149, 1.00)),
            AnimateCard(title: 'DJ',number: snapSub.hasData&&snapSub.data['code']==200?snapSub.data['djRadioCount']:0,color: Color.fromRGBO(204, 171, 218, 1.00))
          ],
        );
      },
    )
);
// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  final double width;
  final double height;
  TopBarClipper(this.width, this.height);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(width, height);
    path.lineTo(width, 0.0);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

