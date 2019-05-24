import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:icloudmusic/component/searchContextScreen.dart';
import 'package:icloudmusic/component/loading.dart';
import 'package:icloudmusic/utils/commotRequest.dart';
import 'package:icloudmusic/const/resource.dart';

class HomeSScreen extends StatefulWidget {
  @override
  _HomeSScreenState createState() => _HomeSScreenState();
}

class _HomeSScreenState extends State<HomeSScreen> {
  bool _isLoad = true;
  TextEditingController _searchContext = TextEditingController();
  String _suggest; // 搜索建议
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Text(""),
            middle: Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoTextField(
                      controller: _searchContext,
                      decoration: BoxDecoration(
                          color: C.OPACITY_DEF,
                          borderRadius: BorderRadius.circular(25.0)),
                      padding: EdgeInsets.only(
                          left: 10, top: 5, bottom: 5, right: 10),
                      prefix: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Icon(
                          CupertinoIcons.search,
                          color: Color.fromRGBO(1, 1, 1, 0.3),
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      placeholder: "搜索",
                      placeholderStyle: TextStyle(
                        fontFamily: F.Medium,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(1, 1, 1, 0.3),
                      ),
                      style: TextStyle(
                        fontFamily: F.Medium,
                      ),
                      autofocus: false,
                      onSubmitted: (v) {
                        // 按下回车按钮调用搜索方法（这里使用的是router）
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (BuildContext context) {
                          return SearchScreen(searchString: v);
                        }));
                      },
                      onChanged: (e) {
                        this._suggest = e;
                        setState(() {});
                      },
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "取消",
                      style: TextStyle(color: C.DEF, fontFamily: F.Medium),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                  )
                ],
              ),
            ),
            padding: EdgeInsetsDirectional.only(end: 0),
            trailing: CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                CupertinoIcons.profile_circled,
                color: C.DEF,
                size: 26,
              ),
              padding: EdgeInsets.all(5),
            ),
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            border: null),
        child: FutureBuilder(
          future: H.searchSuggest(_suggest),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.hasData &&
                snap.data['code'] == 200 &&
                snap.data['result'].toString() != '{}' &&
                snap.data['result']['order'].length > 0) {
              return Container(
                child: ListView(children: <Widget>[
                  snap.data['result']['artists'] != null
                      ? Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: Text('ARTIST',
                                  style: TextStyle(
                                      fontFamily: F.Light, fontSize: 13)),
                            ),
                            artistS(snap.data['result']['artists'])
                          ],
                        )
                      : Container(),
                  snap.data['result']['songs'] != null
                      ? Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: Text('MUSIC',
                                  style: TextStyle(
                                      fontFamily: F.Light, fontSize: 13)),
                            ),
                            songS(snap.data['result']['songs'])
                          ],
                        )
                      : Container(),
                  snap.data['result']['playlists'] != null
                      ? Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: Text('PLAYLIST',
                                  style: TextStyle(
                                      fontFamily: F.Light, fontSize: 13)),
                            ),
                            playlistS(snap.data['result']['playlists'])
                          ],
                        )
                      : Container(),
                  snap.data['result']['mvs'] != null
                      ? Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: Text('MV',
                                  style: TextStyle(
                                      fontFamily: F.Light, fontSize: 13)),
                            ),
                            mvS(snap.data['result']['mvs'])
                          ],
                        )
                      : Container(),
                  snap.data['result']['albums'] != null
                      ? Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: Text('ALBUM',
                                  style: TextStyle(
                                      fontFamily: F.Light, fontSize: 13)),
                            ),
                            albumS(snap.data['result']['albums'])
                          ],
                        )
                      : Container(),
                ]),
              );
            }
            return Container(
              child: _isLoad
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: Container(
                            width: 40.0,
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: F.Regular,
                                color: index < 3 ? Colors.red : Colors.grey,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          title: Row(
                            children: <Widget>[
                              Text(
                                recentSuggest[index]['title'],
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontFamily: F.Bold, color: C.DEF),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  recentSuggest[index]['hotnum'].toString(),
                                  style: TextStyle(
                                      fontFamily: F.Medium,
                                      color:
                                          index < 3 ? Colors.red : Colors.grey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13),
                                ),
                              ),
                              recentSuggest[index]['hot']
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.whatshot,
                                        color: Colors.red,
                                      ))
                                  : Container()
                            ],
                          ),
                          subtitle: Text(
                            recentSuggest[index]['subtitle'],
                            style: TextStyle(fontFamily: F.Medium),
                          ),
                          onTap: () {
                            setState(() {
                              _searchContext.text =
                                  recentSuggest[index]['title'];
                            });
                            Navigator.push(context, CupertinoPageRoute(
                                builder: (BuildContext context) {
                              return SearchScreen(
                                  searchString: _searchContext.text);
                            }));
                          },
                        );
                      },
                      itemCount: recentSuggest.length,
                    )
                  : loadingWidgetTwo(),
            );
          },
        ),
      ),
    ));
  }
}

// 歌单
Widget playlistS(d) {
  List<Widget> _playlistS = List();
  d.forEach((e) {
    String _picUrl = '';
    String _name = '';
    String _description = '';
    _picUrl = e['coverImgUrl'];
    _name = e['name'];
    _description = e['description'];
    Widget _item = Container(
      margin: EdgeInsets.only(bottom: 15.0, left: 15.0),
      child: ClipRRect(
        child: Container(
          alignment: Alignment.center,
          width: 350.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: NetworkImage(_picUrl), fit: BoxFit.cover),
          ),
          child: Container(
            color: Colors.grey.withAlpha(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 8.0, sigmaX: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(40),
                          image: DecorationImage(
                              image: NetworkImage(_picUrl), fit: BoxFit.cover)),
                    ),
                    Container(
                      width: 200.0,
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey.withAlpha(40),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(_name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: F.Light,
                                        fontSize: 16.0,
                                        color: Colors.white)),
                              )),
                          Container(
                            height: 135.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey.withAlpha(40),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  _description.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: F.Light),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
    _playlistS.add(_item);
  });

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _playlistS),
      ));
}

// 专辑
Widget albumS(d) {
  List<Widget> _albumS = List();
  d.forEach((e) {
    String _picUrl = '';
    String _name = '';
    List<Widget> _subS = List();
    e['artist']['alias'] != null
        ? e['artist']['alias'].forEach((es) {
            Widget _subItems = Container(
              margin: EdgeInsets.only(left: 8.0),
              padding: EdgeInsets.only(
                  top: 5.0, left: 10.0, bottom: 5.0, right: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(colors: C.BTN_DEF)),
              child: Text(es.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: F.Light,
                      color: Colors.white,
                      fontSize: 13.0)),
            );
            _subS.add(_subItems);
          })
        : print('没有标签');
    e['artist']['picUrl'] != null
        ? _picUrl = e['artist']['picUrl']
        : _picUrl = e['artist']['img1v1Url'];
    _name = e['name'];

    Widget _item = Container(
      margin: EdgeInsets.only(bottom: 15.0, left: 15.0),
      child: ClipRRect(
        child: Container(
          alignment: Alignment.center,
          width: 190.0,
          height: 280.0,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: NetworkImage(_picUrl), fit: BoxFit.cover),
          ),
          child: Container(
            color: Colors.grey.withAlpha(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 8.0, sigmaX: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage: NetworkImage(_picUrl),
                        backgroundColor: C.colorRandom,
                        radius: 94.5),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(50),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(_name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: F.Regular,
                              fontSize: 16.0,
                              color: Colors.white)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _subS,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(135.0),
            topRight: Radius.circular(135.0),
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0)),
      ),
    );
    _albumS.add(_item);
  });

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _albumS),
      ));
}

// MV
Widget mvS(d) {
  List<Widget> _mvS = List();
  d.forEach((e) {
    String _picUrl = '';
    String _name = '';
    List<Widget> _subS = List();
    e['artists'][0]['alias'] != null
        ? e['artists'][0]['alias'].forEach((es) {
            Widget _subItems = Container(
              padding: EdgeInsets.only(
                  top: 5.0, left: 10.0, bottom: 5.0, right: 10.0),
              margin: EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(colors: C.BTN_DEF)),
              child: Text(es.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: F.Light,
                      color: Colors.white,
                      fontSize: 13.0)),
            );
            _subS.add(_subItems);
          })
        : print('没有标签');
    _picUrl = e['cover'];
    _name = e['name'];

    Widget _itemMvS = Container(
      margin: EdgeInsets.only(bottom: 15.0, left: 15.0),
      width: 290.0,
      height: 230.0,
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(_picUrl), fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.grey.withAlpha(40),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_picUrl),
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(40),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(_name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: F.Regular,
                              fontSize: 16.0,
                              color: Colors.white)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: _subS),
                    ),
                  ]),
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
    _mvS.add(_itemMvS);
  });

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _mvS),
    ),
  );
}

// 歌
Widget songS(d) {
  List<Widget> _songS = List();
  d.forEach((e) {
    String _alias = '';
    String _picUrl = '';
    String _name = '';
    String _user = '';
    int _duration = 0;
    e['alias'].forEach((es) {
      _alias += es;
    });
    _picUrl = e['album']['artist']['img1v1Url'];
    _name = e['name'];
    _user = e['artists'][0]['name'];
    _duration = e['duration'];

    Widget _item = Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: D.sWidth - 20,
      child: ClipRRect(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                image: DecorationImage(
                    image: NetworkImage(_picUrl), fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 8.0, sigmaX: 8.0),
              child: Container(
                color: Colors.grey.withAlpha(40),
                child: Row(children: <Widget>[
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(55.0)),
                        image: DecorationImage(
                            image: NetworkImage(_picUrl), fit: BoxFit.cover)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: D.sWidth - 205,
                          margin: EdgeInsets.only(left: 8.0),
                          child: Text(' $_name',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: F.Regular,
                                  fontSize: 16.0,
                                  color: Colors.white))),
                      Container(
                          width: D.sWidth - 165,
                          margin: EdgeInsets.only(left: 8.0),
                          child: Text(' ${_alias != '' ? _alias : _user}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: F.Light,
                                  color: Colors.white70,
                                  fontSize: 12.0))),
                    ],
                  ),
                  _duration > 300000
                      ? Icon(Icons.whatshot, color: Colors.red)
                      : Icon(Icons.music_note, color: Colors.white70),
                  Container(
                    child: Text(
                      '$_duration',
                      style: TextStyle(
                          fontFamily: F.Light,
                          color:
                              _duration > 300000 ? Colors.red : Colors.white70,
                          fontWeight: FontWeight.w300,
                          fontSize: 13.0),
                    ),
                  )
                ]),
              ),
            )),
        borderRadius: BorderRadius.circular(65.0),
      ),
    );

    _songS.add(_item);
  });
  return Column(children: _songS);
}

// 歌手
Widget artistS(d) {
  List<Widget> _artistS = List();
  d.forEach((e) {
    String _alias = '';
    String _picUrl = '';
    String _name = '';
    e['alias'].forEach((es) {
      _alias += es;
    });
    _picUrl = e['img1v1Url'];
    _name = e['name'];

    Widget _item = Container(
      alignment: Alignment.center,
      width: 115.0,
      margin: EdgeInsets.only(bottom: 28.0, left: 15.0, right: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(40),
            image: DecorationImage(
                image: NetworkImage(_picUrl),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 8.0, sigmaX: 8.0),
            child: Container(
              color: Colors.grey.withAlpha(40),
              padding: EdgeInsets.only(bottom: 10.0),
              child: Column(children: <Widget>[
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(_picUrl),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(_name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontFamily: F.Medium, color: Colors.white)),
                ),
                Text(_alias,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: F.Light,
                        color: Colors.white,
                        fontSize: 13.0)),
              ]),
            ),
          ),
        ),
      ),
    );
    _artistS.add(_item);
  });
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _artistS),
  );
}

// 热搜数据
List<Map<String, dynamic>> recentSuggest = [
  {
    "title": "只因你太美",
    "hotnum": 4012771,
    "subtitle": "一起见证全新实力男团时代的开启",
    "hot": true
  },
  {
    "title": "雨夜冷",
    "hotnum": 4012770,
    "subtitle": "听完Beyond这首歌，心也被寂寞包裹",
    "hot": true
  },
  {
    "title": "心如止水",
    "hotnum": 3114600,
    "subtitle": "水声和男声温柔得心都要化了！",
    "hot": true
  },
  {
    "title": "孤单心事",
    "hotnum": 2992283,
    "subtitle": "颜人中的全新演绎带你一起走出心事～",
    "hot": false
  },
  {
    "title": "归去来兮",
    "hotnum": 2089200,
    "subtitle": "花粥的最新专辑上线了，快来听歌吧！",
    "hot": false
  },
  {
    "title": "人间不值得",
    "hotnum": 1540400,
    "subtitle": "人间不值得，但音乐值得",
    "hot": false
  },
  {
    "title": "慢慢喜欢你",
    "hotnum": 1458200,
    "subtitle": "莫文蔚新歌给你细水长流的甜蜜浪漫",
    "hot": true
  },
  {
    "title": "撕夜",
    "hotnum": 1457700,
    "subtitle": "小时候还以为是情歌，现在才听出其中的现实",
    "hot": false
  },
  {
    "title": "我曾",
    "hotnum": 1243900,
    "subtitle": "总不能还没努力就向生活妥协吧",
    "hot": false
  },
  {"title": "孤身", "hotnum": 1243300, "subtitle": "原创音乐徐斌龙最新单曲", "hot": false},
  {
    "title": "大碗宽面",
    "hotnum": 931900,
    "subtitle": "吴亦凡最新单曲上线！快来支持！",
    "hot": false
  },
  {
    "title": "lemon",
    "hotnum": 741790,
    "subtitle": "米津玄师献唱日剧《非自然死亡》主题曲",
    "hot": true
  }
];
