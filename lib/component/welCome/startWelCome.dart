import 'dart:math';
import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/sound.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:icloudmusic/utils/logoStack.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/component/welCome/LinearGradientBar.dart';
import 'package:icloudmusic/component/welCome/likeMaterialButton.dart';
import 'package:icloudmusic/component/login/myHeroButton.dart';
import 'package:icloudmusic/component/welCome/cdGroup.dart';
// START
class StartWelCome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: DeviceInfo.padding + 10.0),
            alignment: Alignment.center,
            child: LogoStack(),
          ),
          Container(
            height: 319.0,
            width: 325.0,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Hello, Jane Foster.     My name is Aura.",
                  style: TextStyle(
                      fontFamily: "SF-UI-Display-Regular",
                      fontSize: 28.0,
                      height: 1.2,
                      color: Color.fromRGBO(24, 29, 40, 1)
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    "I want to know your musical taste.",
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Regular",
                        fontSize: 28.0,
                        height: 1.2,
                        color: Color.fromRGBO(24, 29, 40, 1)
                    ),
                  ),
                )
              ],
            ),
          ),
          MyHeroButton(
              tag: "STARTWELCOM",
              title: "START",
              callBack: (){
    Navigator.of(context).pushReplacement(
    FadeRoute(StartWelComeOne())
    );
    }
          )
        ],
      ),
    );
  }
}

// What do you love?
class StartWelComeOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: DeviceInfo.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 13.0, top: 15.0),
                  child: Text(
                    "What do you love?",
                    style: TextStyle(
                        fontSize: 28.0,
                        color: Color.fromRGBO(24, 29, 40, 0.87),
                        fontFamily: "SF-UI-Display-Regular"
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        FadeRoute(StartWelComeTwo())
                    );
                  },
                  icon: Text(
                    "skip",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color.fromRGBO(84, 102, 174, 1),
                        fontFamily: "SF-UI-Display-Regular"
                    ),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: 390.0,
                  width: 521,
                  margin: EdgeInsets.only(bottom: 0.0, left: 24.0, right: 24.0),
                  child: TypeCheck()
              )
          ),
          MyHeroButton(
            title: "NEXT",
            tag: 'STARTWELCOM',
            callBack: (){
              Navigator.of(context).pushReplacement(
              FadeRoute(StartWelComeTwo())
              );
              }
          )
        ],
      ),
    );
  }
}
// How about this song?
class StartWelComeTwo extends StatefulWidget {
  @override
  _StartWelComeTwoState createState() => _StartWelComeTwoState();
}
class _StartWelComeTwoState extends State<StartWelComeTwo>
    with SingleTickerProviderStateMixin {
  ValueNotifierData _state = ValueNotifierData(PlaySound.state); // 监听播放状态
  ValueNotifierData _name = ValueNotifierData(musicBase[0]['name']);
  ValueNotifierData _artists = ValueNotifierData(musicBase[0]['artists']);
  ValueNotifierData _maxDuration = ValueNotifierData(PlaySound.maxDuration);
  ValueNotifierData _value = ValueNotifierData(PlaySound.value);
  setPlay(state ,value, maxDuration){
    if(_state.value != state) {
      _state.value = state;
    }
    if(value != null){
      _maxDuration.value = maxDuration;
      _value.value = value;
    }
  }
  // 当前播放的索引
  int onTop = 0;
  @override
  void initState() {
    PlaySound.uri = musicBase[0]['url']; // 默认的播放链接
    super.initState();
  }

  @override
  void dispose() {
    _state.dispose();
    _name.dispose();
    _artists.dispose();
    _maxDuration.dispose();
    _value.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
              child: Container(
                  height: 200.0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      WaveWidget(
                        config: CustomConfig(
                          gradients: <List<Color>>[
                            <Color>[
                              Color.fromRGBO(233, 136, 124, 0.8),
                              Color.fromRGBO(204, 171, 218, 0.8)
                            ],
                            <Color>[
                              Color.fromRGBO(208, 230, 165, 0.8),
                              Color.fromRGBO(245, 221, 149, 0.8)
                            ],
                            <Color>[
                              Color.fromRGBO(245, 221, 149, 0.8),
                              Color.fromRGBO(233, 136, 124, 0.8)
                            ],
                            <Color>[
                              Color.fromRGBO(134, 227, 206, 0.8),
                              Color.fromRGBO(208, 230, 165, 0.8)
                            ]
                          ],
                          durations: [30500, 10944, 10080, 60000],
                          heightPercentages: [0.05, 0.10, 0.15, 0.2],
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        wavePhase: 1.0,
                        waveAmplitude: 0,
                        size: Size(double.infinity, double.infinity),
                      ),

                    ],
                  )
              ),
          ),

          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // title
                Container(
                  margin: EdgeInsets.only(top: DeviceInfo.padding + 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 13.0, top: 15.0),
                        child: Text(
                          "How about this song?",
                          style: TextStyle(
                              fontSize: DeviceInfo.height < 570 ? 24.0 : 28.0,
                              color: Color.fromRGBO(24, 29, 40, 0.87),
                              fontFamily: "SF-UI-Display-Regular"
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'WELCOMEOK',
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                FadeRoute(Complete())
                            );
                          },
                          child: Text(
                            "skip",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Color.fromRGBO(84, 102, 174, 1),
                                fontFamily: "SF-UI-Display-Regular"
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // cd
                CdGroup(
                  state: _state,
                  getData: (data, index){
                    onTop = index; // 当前歌曲的位置
                    _name.value = data['name'];
                    _artists.value = data['artists'];
                  },
                  callback: (state, value, maxDuration){
                    _state.value = state; // 播放状态
                    _value.value = value; // 进度
                    _maxDuration.value = maxDuration; // 长度
                  },
                  data: musicBase
                ),
                Container(
                  height: 70.0,
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: CDName(
                          text: _name,
                            fontFamily: "SF-UI-Display-Semibold",
                          size:20.0,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: CDName(
                          text: _artists,
                          fontFamily: "SF-UI-Display-Regular",
                          size:15.0,
                        )
                      ),
                    ],
                  ),
                ),
                // play
                Container(
                  width: 315.0,
                  margin: EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // unlike
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(84.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(159, 210, 243, 0.35),
                                    blurRadius: 24.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, 12.0))
                              ]
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: LikeMaterialButton(
                                  type: false,
                                  like: musicBase[onTop]['like'],
                                  callback: (){
                                    print("不喜欢");
                                  }
                              )
                          )
                      ),
                      // play && pause
                      Hero(
                        tag: 'STARTWELCOM',
                        child: Container(
                            width: 84.0,
                            height: 84.0,
                            child: PlayButton(
                              state: _state,
                              callback: setPlay
                            )
                        ),
                      ),
                      // like
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(84.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(159, 210, 243, 0.35),
                                    blurRadius: 24.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, 12.0))
                              ]
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: LikeMaterialButton(
                                  type: true,
                                  like: musicBase[onTop]['like'],
                                  callback: (){
                                    musicBase[onTop]['like'] = !musicBase[onTop]['like'];
                                  }
                              )
                          )
                      )
                    ],
                  ),
                ),
                // 占位
                LinearGradientBar(
                  maxDuration: _maxDuration,
                  value: _value,
                  callback: (value){
                    _value.value = value;
                  }
                ),
//                Container(
//                  height: 70.0,
//                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// Complete!
class Complete extends StatelessWidget {
  final sqlLites = new SqlLite();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Color.fromRGBO(28, 224, 218, 1), Color.fromRGBO(71, 157, 228, 1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Hero(
              tag: 'WELCOMEOK',
              child: Container(
                child: Text(
                  "Complete!",
                  style: TextStyle(
                      fontFamily: "SF-UI-Display-Regular",
                      fontSize: 28.0,
                      color: Colors.white,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ),

            Column(
              children: <Widget>[
                Image.asset("assets/images/aura.png"),
                Container(
                  margin: EdgeInsets.only(top: 41.0),
                  child: Text(
                    "Rebel",
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Semibold",
                        fontSize: 30.0,
                        color: Colors.white,
                        decoration: TextDecoration.none
                    ),
                  ),
                ),
                Container(
                  width: 284.0,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(bottom: 100.0),
                  child: Text(
                    "You are an energetic and purposeful person who needs downhole guitar reefs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Regular",
                        fontSize: 15.0,
                        color: Colors.white,
                        decoration: TextDecoration.none
                    ),
                  ),
                ),
              ],
            ),
            Container(
                child: FlatButton(
                  onPressed: () async {
                    // 开启数据库
                    await sqlLites.open();
                    // 修改账户状态，不再是首次使用该程序
                    await sqlLites.db.update("loginState", {"first": 0});
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => route == null);
                  },
                  splashColor: Color.fromRGBO(255, 255, 255, 0.35),
                  highlightColor: Colors.transparent,
                  child: Text(
                    "VIEW RECOMMENDATIONS",
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Regular",
                        fontSize: 18.0,
                        color: Colors.white,
                        decoration: TextDecoration.none
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
// loveType
class TypeCheck extends StatefulWidget {
  @override
  _TypeCheckState createState() => _TypeCheckState();
}

class _TypeCheckState extends State<TypeCheck> {
  final List<Map<String, dynamic>> loveType = [{
  'left': 35.0,
  'top': 35.0,
  'size': 97.64,
  'value': 'Lounge',
  'is': false,
  'gradient': null
  }, {
  'left': 60.0,
  'top': 150.0,
  'size': 72.91,
  'value': 'Punk',
  'is': false,
  'gradient': null
  }, {
  'left': 2.0,
  'top': 230.0,
  'size': 115.87,
  'value': 'Electronic',
  'is': false,
  'gradient': null
  }, {
  'left': 145.0,
  'top': 40.0,
  'size': 160.13,
  'value': 'Alternative',
  'is': false,
  'gradient': null
  }, {
  'left': 125.0,
  'top': 208.0,
  'size': 115.87,
  'value': 'Metal',
  'is': false,
  'gradient': null
  }, {
  'left': 215.0,
  'top': 300.0,
  'size': 67.7,
  'value': 'Pop',
  'is': false,
  'gradient': null
  }, {
  'left': 295.0,
  'top': 0.0,
  'size': 85.92,
  'value': 'Jazz',
  'is': false,
  'gradient': null
  }, {
  'left': 325.0,
  'top': 95.0,
  'size': 97.64,
  'value': 'Rock',
  'is': false,
  'gradient': null
  }, {
  'left': 255.0,
  'top': 195.0,
  'size': 110.66,
  'value': 'Blues',
  'is': false,
  'gradient': null
  }, {
  'left': 415.0,
  'top': 10.0,
  'size': 97.64,
  'value': 'Country',
  'is': false,
  'gradient': null
  }, {
  'left': 380.0,
  'top': 195.0,
  'size': 67.7,
  'value': 'R&B',
  'is': false,
  'gradient': null
  }, {
  'left': 360.0,
  'top': 285.0,
  'size': 88.53,
  'value': 'Rap',
  'is': false,
  'gradient': null
  }];
  @override
  Widget build(BuildContext context) {
    final List<Widget> paoPao = List();
    for (int i = 0; i < loveType.length; i++) {
      paoPao.add(Positioned(
          left: loveType[i]['left'],
          top: loveType[i]['top'],
          child: ColorPao(
            size: loveType[i]['size'],
            value: loveType[i]['value'],
            callBack: (){
              print(loveType[i]['value']);
            },
          )
      ));
    }
    return Stack(
        children: paoPao
    );
  }
}
class ColorPao extends StatefulWidget{
  final double size;
  final String value;
  final callBack;
  ColorPao({
    Key key,
   @required this.value,
   @required this.size,
    this.callBack
}):super(key:key);
  @override
  _ColorPao createState() => _ColorPao();
}
class _ColorPao extends State<ColorPao>{
  bool like = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: like ? LinearGradient(colors: [
            Color.fromRGBO(
                Random().nextInt(60) + 180, Random().nextInt(60) + 180,
                Random().nextInt(60) + 180, 1),
            Color.fromRGBO(
                Random().nextInt(60) + 180, Random().nextInt(60) + 180,
                Random().nextInt(60) + 180, 1)
          ]) : null,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(159, 210, 243, 0.35),
      blurRadius: 24.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 12.0)
    )
  ]
      ),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.callBack();
              // 给喜欢的类型改变状态
              setState(() {
                like = !like;
              });
            },
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              alignment: Alignment.center,
              height: widget.size,
              width: widget.size,
              child: Text(
                "${widget.value}",
                style: TextStyle(
                    color: like ? Colors.white : Color
                        .fromRGBO(24, 29, 40, 0.87),
                    fontSize: 18.0,
                    fontFamily: "SF-UI-Display-Semibold"
                ),
              ),
            ),
          )
      ),
    );
  }
}


List<Map<String, dynamic>> musicBase = <Map<String, dynamic>>[
  {
    'name': '无归',
    'artists': '叶里',
    'url': 'https://music.163.com/song/media/outer/url?id=404465743.mp3',
    "img1v1Url": "https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
    'like': false
  },
  {
    'name': '扉をあけて',
    'artists': 'ANZA',
    'url': 'https://music.163.com/song/media/outer/url?id=555959.mp3',
    "img1v1Url": "https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
    'like': false
  },
  {
    'name': 'Past The Stargazing Season',
    'artists': 'Mili',
    'url': 'https://music.163.com/song/media/outer/url?id=29401202.mp3',
    "img1v1Url": "https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
    'like': false
  }
];