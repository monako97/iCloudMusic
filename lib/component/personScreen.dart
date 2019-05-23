import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/component/animateCard.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:icloudmusic/Utils/commotRequest.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'dart:ui';
class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  double _radius = 30.0;
  @override
  void initState() {
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
          Future<Duration>.delayed(d, () {
            setState(() {
              _radius = 45.0;
            });
          });
        });
      });
    })();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      child: FutureBuilder(
        future: H.getUserDetail(),
        builder: (context,snap){
          return Stack(
            children: <Widget>[
              Container(
                height: D.sWidth-58,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    image: DecorationImage(
                        image: snap.hasData&&snap.data['code']==200 ? NetworkImage(snap.data['profile']['backgroundUrl']) : AssetImage(M.UN),
                        fit: BoxFit.cover
                    )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(' ')
                  ),
                ),
              ),
              EasyRefresh(
                key: _easyRefreshKey,
                behavior: ScrollOverBehavior(),
                refreshHeader: BallPulseHeader(
                  key: _headerKey,
                  color: Colors.green.shade200,
                ),
                onRefresh: (){setState(() {});},
                child: ListView(
                  padding: EdgeInsets.only(top: D.topPadding + 48.0),
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
                                    fontFamily: F.Regular
                                ),
                              ),
                              snap.hasData&&snap.data['code']==200 ? Image.asset(M.BOY,width: 25.0,height: 25.0):Container(),
                            ],
                          ),
                        ),
                        // 图标
                        Container(
                            height: 100.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 100.0),
                            child: CircleAvatar(
                              backgroundImage: snap.hasData&&snap.data['code']==200 ? NetworkImage(snap.data['profile']['avatarUrl']) : AssetImage(M.UN),
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
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Wrap(
                        runSpacing: 20.0,
                        spacing: 20.0,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          AnimateCard(title: 'COLLECTOR',number: 2,color: Color.fromRGBO(233, 136, 124, 1.00)),
                          AnimateCard(title: 'SONG',number: 17,color: Color.fromRGBO(209, 231, 166, 1.00)),
                          AnimateCard(title: 'DYNAMIC',number: 2,color: Color.fromRGBO(245, 221, 149, 1.00)),
                          AnimateCard(title: 'DJ',number: 1,color: Color.fromRGBO(204, 171, 218, 1.00))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}
// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

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

