import 'package:flutter/cupertino.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:icloudmusic/Utils/listData.dart';
import 'package:icloudmusic/Utils/HttpUtil.dart';
import 'package:icloudmusic/component/getInfo.dart';
import 'package:icloudmusic/component/userInfo.dart';
import 'package:icloudmusic/component/searchScreen.dart';
import 'package:icloudmusic/component/nativeWeb.dart';
import 'package:icloudmusic/component/selectionsComponent.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'dart:io';
import 'dart:ui';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  SwiperController _swipeController = SwiperController();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
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
    _bannerData = await H.getBanners();
    return _bannerData;
  }
  // 获取一言
  Future getHit()async{
    _hit = await H.hit();
  }
  @override
  void initState() {
    (() async {
      await H.sqlListData.open();
      List<Map<String, dynamic>> _hitList = await H.sqlListData.queryForm('hitokoto');
      //从本地数据库中取出最后一则一言
      if(_hitList.length>0){
        _hit = _hitList[_hitList.length-1];
      }
      // 首先从本地拿取banner数据
      _bannerData = await H.sqlListData.queryForm("banner");
      await H.sqlLite.open();
      Map<String, dynamic> userInfo = await H.queryUserInIf();
      setState(() {
        _avatarUrl = userInfo['avatarUrl'];
        _userName = userInfo['nickname'];
        _gender = userInfo['gender'];
        _backgroundUrl = userInfo['backgroundUrl'];
        _userId = userInfo['userId'];
      });
    })();
    super.initState();
  }
  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: homeBars(),
      child: Container(
        child: EasyRefresh(
          key: _easyRefreshKey,
          refreshHeader: BezierCircleHeader(
              key: _headerKey,
              color: Colors.white,
              backgroundColor: Colors.redAccent.shade200
          ),
          refreshFooter: BezierBounceFooter(
            key: _footerKey,
            color: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // banner
                bannerViews(),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 25.0),
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
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 5.0,bottom: 25.0),
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
                // 榜单
                homeChart(chartTmpl.sublist(0, 5)),
                // 标题
                titleSub("Hot playlists"),
                // 推荐歌单
                hotPlayLists(playListData),
                // 标题
                titleSub("Selections"),
                selectionsComponent(),
                // 一言
                hitOKOto()
              ],
            ),
          ),
          onRefresh: () {
            setState(() {});
          },
          loadMore: () {
            setState(() {});
          },
        ),
      )
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
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 8.0),
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
    )
  );
  // 轮播
  Widget bannerViews() => FutureBuilder(
    future: H.getBanners(),
    builder: (BuildContext context, snap) {
      if (snap.hasData) {
        return Container(
          height: 150.0,
          margin: EdgeInsets.only(top: D.topPadding + 50),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(left: 18.0, right: 18.0),
                decoration: BoxDecoration(
                    color: C.colorRandom,
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          snap.data[index]['imageUrl']),
                      fit: BoxFit.cover,
                    )),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                  decoration: BoxDecoration(
                      color: colorString(
                          snap.data[index]['titleColor']),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0))),
                  child: Text(
                    snap.data[index]['typeTitle'],
                    style: TextStyle(
                        color: CupertinoColors.white,
                        fontFamily: F.Regular,
                        fontSize: 12.0),
                  ),
                ),
              );
            },
            itemCount: snap.data.length,
            autoplay: true,
            controller: _swipeController,
            autoplayDelay: 5000,
            onTap: (i) {
              // 如果url不为null，则跳转页面
              if (snap.data[i]['url'] != null) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) {
                      return NativeWebCupertino(
                          urls: snap.data[i]['url']);
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
              left: 20.0, right: 20.0, top: D.topPadding + 50),
          decoration: BoxDecoration(
              color: C.colorRandom,
              borderRadius: BorderRadius.circular(8.0)),
        );
      }
    },
  );
  // 一言
  Widget hitOKOto()=> FutureBuilder(
    future: H.hit(),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      return Card(
        margin: EdgeInsets.fromLTRB(20.0,10.0,20.0,35.0),
        color: Color.fromRGBO(204, 171, 218, 1),
        child: InkWell(
          onTap: ()=>setState((){}),
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(snapshot.hasData?snapshot.data['hitokoto']:"",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: F.Regular)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(snapshot.hasData?'${snapshot.data['froms']}':"",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: F.Medium)),
                  ),

                ],
              )
          ),
        ),
      );
    },
  );
  // 新歌推荐
  Widget newRelease()=>Column(
    children: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(20.0,0,20.0,0.0),
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
          padding: EdgeInsets.only(right: 20.0),
          child: newReleaseTemp(newReleaseTmpl)
      )
    ],
  );
  @override
  bool get wantKeepAlive => true;
}
// 榜单
Widget homeChart(d){
  final List<Widget> _charts = List();
  Widget _icon(s){
    Widget _ics;
    switch(s){
      case 0:
        _ics = Icon(Icons.remove,
          color: Colors.grey,
        );
        break;
      case 1:
        _ics = Icon(Icons.arrow_drop_up,
          color: Colors.green,
        );
        break;
      case 2:
        _ics = Icon(Icons.arrow_drop_down,
          color: Colors.red,
        );
        break;
      default:
        break;
    }
    return _ics;
  }
  for(int i = 0;i < d.length;i++){
    Widget _item = Container(
      margin: EdgeInsets.only(left: 15.0,right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${i+1}",
                style: TextStyle(
                    color: Color.fromRGBO(24, 29, 40, 0.36),
                    fontSize: 18.0,
                    fontFamily: F.Medium
                ),
              ),
              _icon(d[i]['state'])
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 18, 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              boxShadow: C.list5BoxShadow[i],
              border: Border.all(color: Colors.white,width: 2.0),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(d[i]['img']),
              backgroundColor: Colors.transparent,
              radius: 31,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: Colors.white,width: 2.0)
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${d[i]['name']}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: C.DEF,
                        fontSize: 16.0,
                        fontFamily: F.SemiBold
                    )
                ),
                Text("${d[i]['user']}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: F.Regular,
                      color: Color.fromRGBO(112, 112, 112, 1)
                  ),
                )
              ],
            ),
          ),
          CupertinoButton(
            onPressed: (){
              print("more_vert");
            },
            padding: EdgeInsets.only(right: 0,left: 20),
            child: Icon(
              Icons.more_vert,
              color: Color.fromRGBO(24, 29, 40, 0.54),
            ),
          )
        ],
      ),
    );
    _charts.add(_item);
  }

  return Container(
    margin: EdgeInsets.only(top: 10.0),
    child: Column(
      children: _charts,
    ),
  );
}
// 标题
Widget titleSub(String t) => Container(
  margin: EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
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
// 新歌
Widget newReleaseTemp(d){
  List<Widget> _newReleaseList = List();
  for(int i = 0; i<d.length;i++){
    Widget item = Container(
      margin: EdgeInsets.fromLTRB(20.0, 15.0, 0, 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(64),
        boxShadow: C.list5BoxShadow[i],
        border: Border.all(color: Colors.white,width: 2.0),
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage(d[i]['img']),
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
  }
  return Row(
    children: _newReleaseList,
  );
}
// 推荐歌单
Widget hotPlayLists(d){
  List<Widget> _playLists = List();
  for(int i = 0;i < d.length;i++){
    final Widget _item = Container(
      width: 155.0,
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                left: 25.5,
                right: 25.5,
                top: 43.0,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: C.PLAYLISTColor[i],
                          blurRadius: 24.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 18.0),
                        )
                      ]
                  ),
                ),
              ),
              Container(
                height: 155.0,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: AssetImage(playListData[i]['img']),
                        alignment: Alignment.center,
                        fit: BoxFit.cover
                    )
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(playListData[i]['name'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: F.SemiBold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            width: 155.0,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(playListData[i]['briefing'],
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                  fontFamily: F.Regular,
                  fontSize: 13.0,
                  color: Color.fromRGBO(112, 112, 112, 1)
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.favorite_border,
                      size: 16,
                      color: C.DEF
                  ),
                  Text("  "+"${playListData[i]['like']}",
                    style: TextStyle(
                        fontFamily: F.Regular,
                        fontSize: 14.0,
                        color: C.DEF
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.track_changes,
                    size: 16,
                    color: C.DEF,
                  ),
                  Text("  ${playListData[i]['like']}"+"   tracks",
                    style: TextStyle(
                      fontFamily: F.Regular,
                      fontSize: 14.0,
                      color: C.DEF,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
    _playLists.add(_item);
  }
  return Container(
    alignment: Alignment.center,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: (D.sWidth-40-310)/2,
      children: _playLists,
    ),
  );
}

// 推荐新歌data
List<Map<String,dynamic>> newReleaseTmpl = [{
    "img": M.CD1
  },{
    "img": M.CD2
  },{
    "img": M.CD3
  },{
    "img": M.CD4
  },{
    "img": M.CD5
  }];
// 0：排名不变，1：上升，2：下降
List<Map<String,dynamic>> chartTmpl = [{
    "img": M.CD6,
    "state": 0,
    "name": "Nice For What",
    "user": "Drake"
  },{
    "img": M.CD7,
    "state": 1,
    "name": "Psycho",
    "user": "Post Malone Feat. Ty Dolla Ign"
  },{
    "img": M.CD8,
    "state": 2,
    "name": "Never Be The Same",
    "user": "Camila Cabello"
  },{
    "img": M.CD9,
    "state": 0,
    "name": "Mine",
    "user": "Bazzi"
  },{
    "img": M.CD10,
    "state": 0,
    "name": "Powerglide",
    "user": "Rae Sremmurd Feat. Juicy J"
  }];
// 推荐歌单data
List<Map<String,dynamic>> playListData = [{
  "img": M.PLAYLIST1,
  "name": "Just rock it",
  "briefing": "All the most recent and coolest new rock",
  "like": 547,
  "tracks": 50
},{
  "img": M.PLAYLIST2,
  "name": "Hype",
  "briefing": "Listen to the most trending tracks in one playlist",
  "like": 647,
  "tracks": 70
},{
  "img": M.PLAYLIST3,
  "name": "Loud new month's",
  "briefing": "Surprises and expected novelties",
  "like": 537,
  "tracks": 76
},{
  "img": M.PLAYLIST4,
  "name": "Alternative",
  "briefing": "The novelties of the current alternative music in one playlist",
  "like": 547,
  "tracks": 56
}];