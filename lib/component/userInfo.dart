import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

// 获取状态栏高度
double topPadding = MediaQueryData.fromWindow(window).padding.top;
double screenH = MediaQueryData.fromWindow(window).size.height;

class UserInfoScreen extends StatefulWidget {
  final String avatarUrl; // 头像
  final String username; //用户名
  final int gender; // 性别
  final String backgroundUrl; // 背景
  final int userId;

  UserInfoScreen(
      {Key key,
      @required this.avatarUrl,
      @required this.username,
      @required this.gender,
      @required this.backgroundUrl,
      @required this.userId})
      : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  double _radius = 30.0;
  List<dynamic> _playlist = [];
  var value;
  bool isExpanded = false;

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
    (() async {
      // 获取用户歌单信息
      Map<String, dynamic> result = await HttpUtils.request('/user/playlist',
          data: {'uid': widget.userId}, method: HttpUtils.GET);
      print(result['code']);
      if (result['code'] == 200) {
        _playlist = result['playlist'];
      }
    })();
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
              image: NetworkImage(widget.backgroundUrl),
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
                            EdgeInsets.only(top: topPadding + 80, bottom: 15.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.avatarUrl),
                          radius: _radius,
                        ),
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.username,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'SF-UI-Display-Regular'),
                        ),
                        Image.asset(
                          widget.gender == 1
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
        Material(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: GroovinExpansionTile(
            defaultTrailingIconColor: Colors.indigoAccent,
            title: Container(
              width: 325.0,
              child: Text("sasx"),
            ),
            onExpansionChanged: (value) {
              setState(() {
                isExpanded = value;
              });
            },
            inkwellRadius: !isExpanded
                ? BorderRadius.all(Radius.circular(8.0))
                : BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                  ),
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              "xaaxa",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
