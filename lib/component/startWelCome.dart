import 'package:flutter/material.dart';
import 'package:icloudmusic/component/logoStack.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:icloudmusic/const/resource.dart';

// 获取状态栏高度
double topPadding = MediaQueryData
    .fromWindow(window)
    .padding
    .top;
// 屏幕宽度
double SWidth = MediaQueryData
    .fromWindow(window)
    .size
    .width;
// 屏幕宽度
double SHeight = MediaQueryData
    .fromWindow(window)
    .size
    .height;
class StartWelCome extends StatefulWidget {
  @override
  _StartWelComeState createState() => _StartWelComeState();
}

class _StartWelComeState extends State<StartWelCome> {
  @override
  Widget build(BuildContext context) {
    print(SHeight);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: topPadding + 10.0),
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
                      fontFamily: F.Regular,
                      fontSize: 28.0,
                      height: 1.2,
                      color: C.DEF
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    "I want to know your musical taste.",
                    style: TextStyle(
                        fontFamily: F.Regular,
                        fontSize: 28.0,
                        height: 1.2,
                        color: C.DEF
                    ),
                  ),
                )
              ],
            ),
          ),
          Hero(
            tag: 'STARTWELCOM',
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(colors: C.BTN_DEF),
                  boxShadow: C.BTN_SHADOW),
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, FadeRoute((StartWelComeOne())));
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 325.0,
                      height: 60,
                      child: Text("START",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: F.Regular)
                      ),
                    ),
                  )
              ),
            ),
          ),
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
            margin: EdgeInsets.only(top: topPadding),
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
                        fontFamily: F.Regular
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, FadeRoute((StartWelComeTwo())));
                  },
                  icon: Text(
                    "skip",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color.fromRGBO(84, 102, 174, 1),
                        fontFamily: F.Regular
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
          Hero(
            tag: 'STARTWELCOM',
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(colors: C.BTN_DEF),
                  boxShadow: C.BTN_SHADOW),
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, FadeRoute((StartWelComeTwo())));
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 325.0,
                      height: 60,
                      child: Text("NEXT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: F.Regular)
                      ),
                    ),
                  )
              ),
            ),
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
  // 播放状态
  bool isPlay = false;

  // with 是dart的关键字，意思是混入，就是说可以将一个或者多个类的功能添加到自己的类，无需继承这些类，避免多重继承导致的问题
  AnimationController _controller;

  // 当前播放的索引
  int onTop = 0;

  // 基本信息
  String _name = musicBase[0]['name'];
  String _artists = musicBase[0]['artists'];
  FlutterSound flutterSound = new FlutterSound(); //创建一个播放实例
  StreamSubscription _playerSubscription; //监听播放
  double _value = 0.0; //播放位置
  double max_duration = 1.0; //时长
  bool _isPlaying = false;

  //停止播放
  void stop() async {
    await flutterSound.stopPlayer();
    if (_playerSubscription != null) {
      print("停止播放");
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  void startPlay() async {
    isPlay = false;
    _controller.stop();
    print(_isPlaying);
    if (_isPlaying) {
      // 如果在播放，则先暂停
      print("已有播放");
      flutterSound.stopPlayer();
    }

    await flutterSound.startPlayer(musicBase[onTop]['url']);

    try {
      setState(() {
        this.isPlay = true;
        this._controller.repeat();
        print("开始解析");
      });
      // 开始旋转
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          // 播放位置
          this._value = e.currentPosition;
          // 歌曲时长
          this.max_duration = e.duration;
          this.setState(() {
            if (e.currentPosition < e.duration - 1) {
              this._isPlaying = true;
            } else {
              this._isPlaying = false;
              this.isPlay = false;
              this._controller.stop();
            }
          });
        }
      });
    } catch (err) {
      // 停止旋转
      setState(() {
        isPlay = false;
        _controller.stop();
      });
      print('error: $err');
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
              height: 100.0,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  WaveWidget(
                    config: CustomConfig(
                      gradients: C.WAVE_DEF,
                      durations: [35000, 19440, 10800, 6000],
                      heightPercentages: [0.20, 0.23, 0.25, 0.30],
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                    ),
                    wavePhase: 1.0,
                    waveAmplitude: 0,
                    size: Size(double.infinity, double.infinity),
                  ),
                  Container(
                    height: 20,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: (_value / max_duration) * 414,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: C.BTN_DEF,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // title
                Container(
                  margin: EdgeInsets.only(top: topPadding + 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 13.0, top: 15.0),
                        child: Text(
                          "How about this song?",
                          style: TextStyle(
                              fontSize: 28.0,
                              color: Color.fromRGBO(24, 29, 40, 0.87),
                              fontFamily: F.Regular
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'WELCOMEOK',
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(context, FadeRoute((Complete())));
                          },
                          child: Text(
                            "skip",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Color.fromRGBO(84, 102, 174, 1),
                                fontFamily: F.Regular
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // cd
                Container(
                    height: 300.0,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: AnimatedBuilder(
                              animation: _controller,
                              builder: (BuildContext context, Widget child) {
                                return Transform.rotate(
                                    angle: _controller.value * 2 * pi,
                                    child: child
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200.0),
                                    border: Border.all(color: Color.fromRGBO(
                                        192, 193, 193, 0.2)),
                                    boxShadow: C.CD_SHADOW
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 132.5,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        musicBase[index]['img1v1Url']),
                                    backgroundColor: Colors.white,
                                    radius: 125.0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 27.5,
                                      child: CircleAvatar(
                                        backgroundColor: Color.fromRGBO(
                                            192, 193, 193, 0.35),
                                        radius: 23.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        );
                      },
                      onIndexChanged: (i) {
                        setState(() {
                          onTop = i;
                          _name = musicBase[i]['name'];
                          _artists = musicBase[i]['artists'];
                          startPlay();
                        });
                      },
                      itemCount: musicBase.length,
                      viewportFraction: 0.70,
                      scale: 0.6,
                    )
                ),
                // name
                Container(
                  height: 70.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(_name, style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: F.Semibold,
                            color: C.DEF
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(_artists, style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: F.Regular,
                            color: C.DEF
                        )),
                      ),
                    ],
                  ),
                ),
                // play
                Container(
                  width: 315.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // unlike
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(84.0),
                              boxShadow: C.BTN_SHADOW
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    print('不喜欢');
                                  },
                                  splashColor: Colors.pinkAccent[100],
                                  borderRadius: BorderRadius.circular(84.0),
                                  child: Container(
                                    width: 65.0,
                                    height: 65.0,
                                    padding: EdgeInsets.all(21.0),
                                    child: Icon(Icons.close),
                                  )
                              )
                          )
                      ),
                      // play && pause
                      Hero(
                        tag: 'STARTWELCOM',
                        child: Container(
                            width: 84.0,
                            height: 84.0,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPlay = !isPlay;
                                    if (isPlay) {
                                      _controller.repeat();
                                      if (_isPlaying) {
                                        flutterSound.resumePlayer();
                                      } else {
                                        startPlay();
                                      }
                                    } else {
                                      _controller.stop();
                                      if (_isPlaying) {
                                        flutterSound.pausePlayer();
                                      }
                                    }
                                  });
                                },
                                child: Stack(
                                  children: <Widget>[
                                    FlareActor(
                                      R.ASSET_PLAY_PAUSE_FLR,
                                      animation: isPlay ? "play" : "pause",
                                      color: Color.fromRGBO(176, 139, 227, 1.0),
                                      fit: BoxFit.fitHeight,
                                    ),
                                    FlareActor(
                                      R.ASSET_COUNTER_FLR,
                                      animation: isPlay ? "play" : "",
                                      isPaused: isPlay ? false : true,
                                    ),
                                  ],
                                )
                            )
                        ),
                      ),
                      // like
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(84.0),
                              boxShadow: C.BTN_SHADOW
                          ),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    setState(() => musicBase[onTop]['like'] =
                                    !musicBase[onTop]['like']);
                                  },
                                  splashColor: Colors.pinkAccent[100],
                                  borderRadius: BorderRadius.circular(84.0),
                                  child: Container(
                                    width: 65.0,
                                    height: 65.0,
                                    padding: EdgeInsets.all(21.0),
                                    child: FlareActor(
                                      R.ASSET_LOVE_FLR,
                                      animation: musicBase[onTop]['like']
                                          ? "Favorite"
                                          : "Unfavorite",
                                      shouldClip: false,
                                    ),
                                  )
                              )
                          )
                      )
                    ],
                  ),
                ),
                // 进度条
                Container(
//                    height: 100.0,
                    child: Slider(
                        onChanged: (double value) async {
                          if (isPlay) {
                            setState(() => _value = value);
                            await flutterSound.seekToPlayer(value.toInt());
                          }
                        },
                        value: _value,
                        min: 0.0,
                        max: max_duration,
                        activeColor: Colors.transparent,
                        inactiveColor: Colors.transparent
                    ),
                ),
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
              colors: C.BTN_DEF,
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
                      fontFamily: F.Regular,
                      fontSize: 28.0,
                      color: Colors.white,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ),

            Column(
              children: <Widget>[
                Image.asset(M.AURA),
                Container(
                  margin: EdgeInsets.only(top: 41.0),
                  child: Text(
                    "Rebel",
                    style: TextStyle(
                        fontFamily: F.Semibold,
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
                        fontFamily: F.Regular,
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
                        context, '/drawer', (route) => route == null);
                  },
                  splashColor: Color.fromRGBO(255, 255, 255, 0.35),
                  highlightColor: Colors.transparent,
                  child: Text(
                    "VIEW RECOMMENDATIONS",
                    style: TextStyle(
                        fontFamily: F.Regular,
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
  final random = Random();
  @override
  Widget build(BuildContext context) {
    List<Widget> Paopao = List();
    for (int i = 0; i < loveType.length; i++) {
      Widget item = Positioned(
        left: loveType[i]['left'],
        top: loveType[i]['top'],
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: loveType[i]['is'] ? loveType[i]['gradient'] : null,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: C.BTN_SHADOW
          ),
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // 给喜欢的类型改变状态
                  setState(() {
                    loveType[i]['is'] = !loveType[i]['is'];
                    if (loveType[i]['is']) {
                      loveType[i]['gradient'] = LinearGradient(colors: [
                        Color.fromRGBO(
                            random.nextInt(60) + 180, random.nextInt(60) + 180,
                            random.nextInt(60) + 180, 1),
                        Color.fromRGBO(
                            random.nextInt(60) + 180, random.nextInt(60) + 180,
                            random.nextInt(60) + 180, 1)
                      ]);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  alignment: Alignment.center,
                  height: loveType[i]['size'],
                  width: loveType[i]['size'],
                  child: Text(
                    "${loveType[i]['value']}",
                    style: TextStyle(
                        color: loveType[i]['is'] ? Colors.white : Color
                            .fromRGBO(24, 29, 40, 0.87),
                        fontSize: 18.0,
                        fontFamily: F.Semibold
                    ),
                  ),
                ),
              )
          ),
        ),
      );
      Paopao.add(item);
    }
    return Stack(
        children: Paopao
    );
  }
}

final List loveType = [
  {
    'left': 35.0,
    'top': 35.0,
    'size': 97.64,
    'value': 'Lounge',
    'is': false,
    'gradient': null
  },
  {
    'left': 60.0,
    'top': 150.0,
    'size': 72.91,
    'value': 'Punk',
    'is': false,
    'gradient': null
  },
  {
    'left': 2.0,
    'top': 230.0,
    'size': 115.87,
    'value': 'Electronic',
    'is': false,
    'gradient': null
  },
  {
    'left': 145.0,
    'top': 40.0,
    'size': 160.13,
    'value': 'Alternative',
    'is': false,
    'gradient': null
  },
  {
    'left': 125.0,
    'top': 208.0,
    'size': 115.87,
    'value': 'Metal',
    'is': false,
    'gradient': null
  },
  {
    'left': 215.0,
    'top': 300.0,
    'size': 67.7,
    'value': 'Pop',
    'is': false,
    'gradient': null
  },
  {
    'left': 295.0,
    'top': 0.0,
    'size': 85.92,
    'value': 'Jazz',
    'is': false,
    'gradient': null
  },
  {
    'left': 325.0,
    'top': 95.0,
    'size': 97.64,
    'value': 'Rock',
    'is': false,
    'gradient': null
  },
  {
    'left': 255.0,
    'top': 195.0,
    'size': 110.66,
    'value': 'Blues',
    'is': false,
    'gradient': null
  },
  {
    'left': 415.0,
    'top': 10.0,
    'size': 97.64,
    'value': 'Country',
    'is': false,
    'gradient': null
  },
  {
    'left': 380.0,
    'top': 195.0,
    'size': 67.7,
    'value': 'R&B',
    'is': false,
    'gradient': null
  },
  {
    'left': 360.0,
    'top': 285.0,
    'size': 88.53,
    'value': 'Rap',
    'is': false,
    'gradient': null
  }
];
List<Map<String, dynamic>> musicBase = [
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