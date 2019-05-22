import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'dart:ui';
class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> with AutomaticKeepAliveClientMixin {
  Map<String,dynamic> _loginStatus;
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  final sLite = SqlLite();
  List<Map<String, dynamic>> _user;
  double _radius = 30.0;
  // 获取当前登录状态
  Future utilsLoginStatus()async{
    _loginStatus = await HttpUtils.request('/login/status',method: HttpUtils.POST);
    setState(() {});
  }
  @override
  void initState() {
    utilsLoginStatus();
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
    (()async{
      await sLite.open();
      _user =  await sLite.queryUserInfo();
      setState(() {});
    })();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 检查用户登录状态 登录状态失效时，删除用户信息
    if(_loginStatus!=null&&_loginStatus['code']==301){
      print("是");
      (()async{
        await sLite.open();
        await sLite.delLoginInfo();
        Navigator.pushNamedAndRemoveUntil(
            context, '/start', (route) => route == null);
      })();
    }
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        image: DecorationImage(
                            image: _user == null ? AssetImage(M.UN) : NetworkImage(_user[0]['backgroundUrl']),
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
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          EasyRefresh(
            key: _easyRefreshKey,
            behavior: ScrollOverBehavior(),
            refreshHeader: BallPulseHeader(
              key: _headerKey,
              color: Colors.redAccent.shade200,
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
                            _user!=null?_user[0]['nickname']:"NAME",
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontFamily: F.Regular
                            ),
                          ),
                          Image.asset(M.BOY,width: 25.0,height: 25.0,),
                        ],
                      ),
                    ),
                    // 图标
                    Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.0),
                      child: CircleAvatar(
                        backgroundImage: _user == null ? AssetImage(M.UN) : NetworkImage(_user[0]['avatarUrl']),
                        backgroundColor: Colors.transparent,
                        radius: _radius,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                        ),
                      )
                    ),
                  ],
                ),
                // 内容
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    height: 400,
                    child: Container(
                      child: Text(_user!=null?_user[0]['nickname']:"NAME",),
                    )
                )
              ],
            ),
          ),
        ],
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

