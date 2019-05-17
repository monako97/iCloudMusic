import 'package:flutter/cupertino.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/Utils/listData.dart';
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/component/userInfo.dart';
import 'package:icloudmusic/component/searchScreen.dart';
import 'package:icloudmusic/component/nativeWeb.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  SwiperController _swiperController = SwiperController();
  bool _msgNew = false;
  final sqlLite = SqlLite();
  final sqlList = SqlListData();
  List<Map<String, dynamic>> _bannerData;
  int _device;
  String _avatarUrl; // 头像
  String _userName; // 用户名
  int _gender; // 性别
  int _userId;
  String _backgroundUrl; // 背景
  Future getBanners() async {
    if (Platform.isIOS) {
      //ios相关代码
      this._device = 2;
    } else if (Platform.isAndroid) {
      //android相关代码
      this._device = 1;
    } else {
      this._device = 0;
    }
    // 从服务端获取banner
    Map<String, dynamic> _banner = await HttpUtils.request('/banner',
        data: {"type": this._device}, method: HttpUtils.GET);
    if (_banner['code'] == 200) {
      await sqlList.delForm("banner");
      _banner['banners'].forEach((e) async {
        await sqlList.insertForm("banner", e);
      });
    } else {
      print("获取banner数据失败");
    }
    _bannerData = await sqlList.queryForm("banner");
    return _bannerData;
  }

  @override
  void initState() {
    (() async {
      await sqlList.open();
      // 首先从本地拿取banner数据
      _bannerData = await sqlList.queryForm("banner");
      await sqlLite.open();
      var userInfo = await sqlLite.queryUserInfo();
      setState(() {
        _avatarUrl = userInfo[0]['avatarUrl'];
        _userName = userInfo[0]['nickname'];
        _gender = userInfo[0]['gender'];
        _backgroundUrl = userInfo[0]['backgroundUrl'];
        _userId = userInfo[0]['userId'];
      });
    })();
    super.initState();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: homeBars(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: getBanners(),
            builder: (BuildContext context, snap) {
              if (snap.hasData) {
                return bannerViews();
              } else {
                return Container(
                  height: 150.0,
                  margin: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: D.topPadding + 48),
                  decoration: BoxDecoration(
                      color: C.ColorRandom,
                      borderRadius: BorderRadius.circular(8.0)),
                );
              }
            },
          ),
          Column(
            children: <Widget>[
              Container(
                child: Text("Dark side Breaking Benjamin",
                    style: TextStyle(
                        color: Color.fromRGBO(24, 29, 40, 0.87),
                        fontSize: 20.0,
                        fontFamily: F.Bold)),
              ),
              Container(
                child: Text("The new album by the American Alt-rockers",
                    style: TextStyle(
                        color: Color.fromRGBO(24, 29, 40, 0.64),
                        fontSize: 15.0,
                        fontFamily: F.Regular)),
              ),
            ],
          )
        ],
      ),
    );
  }
  // 正常搜索条
  Widget homeBars() => CupertinoNavigationBar(
    backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
    border: null,
    middle: GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) {
              return HomeSScreen();
            }));
      },
      child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: C.DEFO),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Icon(CupertinoIcons.search,
                    size: 19.0, color: Color.fromRGBO(1, 1, 1, 0.3)),
              ),
              Text("搜索",
                  style: TextStyle(
                      fontFamily: F.Medium,
                      color: Color.fromRGBO(1, 1, 1, 0.3),
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0)),
            ],
          )),
    ),
    leading: GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
          return UserInfoScreen(
              avatarUrl: _avatarUrl,
              username: _userName,
              gender: _gender,
              backgroundUrl: _backgroundUrl,
              userId: _userId);
        }));
      },
      child: Container(
        width: 35.0,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: _avatarUrl == null
                  ? AssetImage(M.UN)
                  : NetworkImage(_avatarUrl),
              fit: BoxFit.cover,
            )),
      ),
    ),
    trailing: GestureDetector(
      onTap: () {
        this._msgNew = !(this._msgNew ?? false);
        setState(() {});
      },
      child: Container(
        width: 35.0,
        alignment: Alignment.centerRight,
        child: FlareActor(
          R.ASSET_MSG_FLR,
          animation: this._msgNew ? "Notification Loop" : "",
          isPaused: this._msgNew,
          fit: BoxFit.cover,
          shouldClip: false,
        ),
      ),
    ),
  );
  // 轮播
  Widget bannerViews() => Container(
    height: 150.0,
    margin: EdgeInsets.only(top: D.topPadding + 48),
    child: Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    _bannerData[index]['imageUrl']),
                fit: BoxFit.cover,
              )),
          child: Container(
            padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
            decoration: BoxDecoration(
                color: colorString(
                    _bannerData[index]['titleColor']),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0))),
            child: Text(
              _bannerData[index]['typeTitle'],
              style: TextStyle(
                  color: CupertinoColors.white,
                  fontFamily: F.Regular,
                  fontSize: 12.0),
            ),
          ),
        );
      },
      itemCount: _bannerData.length,
      autoplay: true,
      controller: _swiperController,
      autoplayDelay: 5000,
      onTap: (i) {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) {
              return NativeWebCupertino(
                  urls: 'https://www.bilibili.com');
            }));
        // 如果url不为null，则跳转页面
        if (_bannerData[i]['url'] != null) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) {
                return NativeWebCupertino(
                    urls: _bannerData[i]['url']);
              }));
        }
      },
      pagination: SwiperPagination(
        margin: EdgeInsets.all(0.0),
        builder: SwiperPagination(
            margin: EdgeInsets.all(5.0),
            builder: const DotSwiperPaginationBuilder(
                size: 6.0,
                activeSize: 6.0,
                space: 2.5,
                activeColor: C.RED,
                color: Color.fromRGBO(255, 255, 255, 0.8))),
      ),
    ),
  );
  @override
  bool get wantKeepAlive => true;
}
