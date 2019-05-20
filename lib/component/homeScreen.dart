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
final sqlLite = SqlLite();
final sqlList = SqlListData();
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  SwiperController _swiperController = SwiperController();
  bool _msgNew = false;
  List<Map<String, dynamic>> _bannerData;
  int _device;
  String _avatarUrl; // 头像
  String _userName; // 用户名
  int _gender; // 性别
  int _userId;
  String _backgroundUrl; // 背景
  Map<String, dynamic> _hit = {
    'id': 1147,
    'hitokoto': '人类，在决战之时难道会选择自己不擅长的武器来战斗吗？',
    'type': 'a',
    'froms': '只有神知道的世界',
    'creator': 'darudayu',
    'created_at': '1488116376'
  }; // 一言
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
  // 获取一言
  Future getHit()async{
    Map<String, dynamic> _hits = await HttpUtils.request('https://v1.hitokoto.cn');
    if(_hits['hitokoto']!=null){
      await sqlList.open();
      // 将获取到的一言存入数据
      await sqlList.insertHit(_hits);
      // 取出数据
      List<Map<String, dynamic>> _hitLists = await sqlList.queryForm('hitokoto');
      _hit = _hitLists[_hitLists.length-1];;
      setState(() {});
    }
  }
  @override
  void initState() {
    getHit();
    (() async {
      await sqlList.open();
      List<Map<String, dynamic>> _hitList = await sqlList.queryForm('hitokoto');
      print(_hitList[_hitList.length-1]);
      //从本地数据库中取出最后一则一言
      _hit = _hitList[_hitList.length-1];
      // 首先从本地拿取banner数据
      _bannerData = await sqlList.queryForm("banner");
      await sqlLite.open();
      List<Map<String, dynamic>> userInfo = await sqlLite.queryUserInfo();
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
          // banner
          bannerViews(),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(left: 18.0,right: 18.0,top: 15.0),
            child: Text("Dark side Breaking Benjamin",
              style: TextStyle(
                fontFamily: F.Bold,
                fontSize: 20.0,
                color: C.DEFT
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(left: 18.0,right: 18.0,top: 5.0),
            child: Text("The new album by the American Alt-rockers",
              style: TextStyle(
                  fontFamily: F.Regular,
                  fontSize: 15.0,
                  color: Color.fromRGBO(24, 29, 40, 0.64)
              ),
            ),
          ),
          // 标题
          titleSub("New release"),
          // 新歌推荐
          newRelease(),
          // 标题
          titleSub("Chart"),
          // Chart

          // 一言
          hitOKOto()
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
              borderRadius: BorderRadius.circular(50), color: C.OPACITY_DEF),
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
            color: Colors.grey.shade50,
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
  Widget bannerViews() => FutureBuilder(
    future: getBanners(),
    builder: (BuildContext context, snap) {
      if (snap.hasData) {
        return Container(
          height: 150.0,
          margin: EdgeInsets.only(top: D.topPadding + 48),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                    color: C.colorRandom,
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
              // 如果url不为null，则跳转页面
              if (_bannerData[i]['url'] != null) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) {
                      return NativeWebCupertino(
                          urls: _bannerData[i]['url']);
                    }));
              }else{
                // 随便挑个地方
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (BuildContext context) {
                      return NativeWebCupertino(
                          urls: 'https://www.baidu.com');
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
      } else {
        return Container(
          height: 150.0,
          margin: EdgeInsets.only(
              left: 15.0, right: 15.0, top: D.topPadding + 48),
          decoration: BoxDecoration(
              color: C.colorRandom,
              borderRadius: BorderRadius.circular(8.0)),
        );
      }
    },
  );
  // 一言
  Widget hitOKOto()=> Card(
    margin: EdgeInsets.fromLTRB(18.0,10.0,18.0,0.0),
    child: InkWell(
      onTap: getHit,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(_hit!=null?_hit['hitokoto']:"",
                    style: TextStyle(
                        color: C.DEFT,
                        fontSize: 14.0,
                        fontFamily: F.Regular)),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(_hit!=null?'${_hit['froms']}':"",
                    style: TextStyle(
                        color: C.DEFT,
                        fontSize: 13.0,
                        fontFamily: F.Medium)),
              ),

            ],
          )
      ),
    ),
  );
  // 新歌推荐
  Widget newRelease()=>Column(
    children: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(18.0,0,18.0,0.0),
          alignment: Alignment.bottomLeft,
          child: Text("tracks, albums and compilations",
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: F.Regular,
                color: Color.fromRGBO(24, 29, 40, 0.64)
            ),
          )
      ),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(right: 18.0),
          child: newReleaseTemp()
      )
    ],
  );
  @override
  bool get wantKeepAlive => true;
}

Widget titleSub(String t) => Container(
  margin: EdgeInsets.fromLTRB(18.0,15.0,18.0,0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(t,
            style: TextStyle(
                fontFamily: F.SemiBold,
                fontSize: 30.0,
                color: C.DEFT
            ),
          ),
        ),
        CupertinoButton(
          onPressed: (){
            print(t);
          },
          padding: EdgeInsets.only(right: 0,top: 15),
          child: Text("See all",
            style: TextStyle(
                fontFamily: F.Medium,
                fontSize: 15.0,
                color: Color.fromRGBO(84, 102, 174, 1)
            ),
          ),
        )
      ],
    )
);
Widget newReleaseTemp(){
  List<Widget> _newReleaseList = List();
  newReleaseTmpl.forEach((e){
    Widget item = Container(
      margin: EdgeInsets.fromLTRB(18.0, 10.0, 0, 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(64),
        boxShadow: e['boxShadow'],
        border: Border.all(color: Colors.white,width: 3.0),
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage(e['img']),
        backgroundColor: Colors.transparent,
        radius: 32,
        child: Container(
          width: 16.0,
          height: 16.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white,width: 2.0)
          ),
        ),
      ),
    );
    _newReleaseList.add(item);
  });
  return Row(
    children: _newReleaseList,
  );
}
List<Map<String,dynamic>> newReleaseTmpl = [
  {
    "boxShadow": <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(248, 53, 73, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      ),
    ],
    "img": M.CD1
  },
  {
    "boxShadow": <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(20, 26, 30, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      ),
    ],
    "img": M.CD2
  },
  {
    "boxShadow": <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(122, 43, 60, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      ),
    ],
    "img": M.CD3
  },
  {
    "boxShadow": <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(49, 208, 190, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      ),
    ],
    "img": M.CD4
  },
  {
    "boxShadow": <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(174, 135, 146, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      ),
    ],
    "img": M.CD5
  }
];