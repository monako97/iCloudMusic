import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:video_player/video_player.dart'; //视频播放插件
import 'package:flutter_swiper/flutter_swiper.dart'; //轮播
import 'package:icloudmusic/component/login/login.dart';
import 'package:icloudmusic/component/registration/registration.dart';
import 'package:icloudmusic/component/customeRoute.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> listText;
  @override
  initState() {
    super.initState();
    listText = <String>[
      "Millions of tracks",
      "Playlists for any mood",
      "New music every day",
      "Ability to download tracks",
      "High sound quality"
    ];
  }
  @override
  dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
    return Scaffold(
      body: Center(
          child: Stack(
            children: <Widget>[
              VideoBackground(),
              Positioned(
                bottom: 230.0,
                left: 25.0,
                right: 25.0,
                child: Container(
                  alignment: Alignment.center,
                  height: 300.0,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          "${listText[index]}",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: "SF-UI-Display-Regular"),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    autoplay: true,
                    itemWidth: 300,
                    itemHeight: 180.0,
                    itemCount: listText.length,
                    pagination: SwiperPagination(),
                  ),
                )
              ),
              // 按钮
              Positioned(
                bottom: 50.0,
                left: 25.0,
                right: 25.0,
                height: 60.0,
                child: BlockLevelButton(
                    isBgColor: false,
                    borderColors: Colors.white,
                    textCon: ["I have an account. ", "ENTER"],
                    nextPage: Login()
                ),
              ),
              Positioned(
                  bottom: 130.0,
                  left: 25.0,
                  right: 25.0,
                  height: 60.0,
                  child: Hero(
                    tag: 'LOGIN',
                    child: BlockLevelButton(
                        isBgColor: true,
                        borderColors: Colors.transparent,
                        textCon: ["I'M A NEW USER"],
                        nextPage: Registration()
                    ),
                  )
              ),
            ],
          )),
    );
  }
}
class VideoBackground extends StatefulWidget{
  @override
  _VideoBackground createState() => _VideoBackground();
}
class _VideoBackground extends State<VideoBackground>{
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/video/splash.mp4");
    // 在初始化完成后必须更新界面
    _controller
      ..initialize().then((_) {
        // 视频为播放状态
        _controller.play();
        // 循环播放
        _controller.setLooping(true);
        setState(() {});
      });
  }
  @override
  dispose(){
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _controller.value.initialized ?
      // 加载成功
      VideoPlayer(_controller)
          :
      Image.asset(
        "assets/images/splash.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
class BlockLevelButton extends StatelessWidget {
  final bool isBgColor;
  final Color borderColors; // 边框色
  final List textCon; // 按钮内容
  final Widget nextPage; //路由
  BlockLevelButton({
    Key key,
    this.borderColors,
    this.isBgColor,
    this.textCon,
    this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
              FadeRoute(
                  this.nextPage
              )
          );
        },
        splashColor: Color.fromRGBO(28, 224, 218, 0.54),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: this.borderColors,
              ),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(159, 210, 243, 0.35),
      blurRadius: 24.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 12.0)
    )
  ],
              gradient: this.isBgColor
                  ? LinearGradient(colors: <Color>[Color.fromRGBO(28, 224, 218, 1), Color.fromRGBO(71, 157, 228, 1)])
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ButtonContent(this.textCon)],
          ),
        ),
      ),
    );
  }
}

// 按钮内容文字
// ignore: must_be_immutable
class ButtonContent extends StatelessWidget {
  final List textCon;
  final List<Widget> btnCon = List();
  Color textColors;

  ButtonContent(this.textCon);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < this.textCon.length; i++) {
      if (this.textCon.length > 1) {
        i == 0 ? textColors = Colors.white70 : textColors = Colors.white;
      } else {
        textColors = Colors.white;
      }
      var itemCon = Text(this.textCon[i],
          style: TextStyle(
              color: textColors,
              fontSize: 18.0,
              fontFamily: "SF-UI-Display-Regular"));
      btnCon.add(itemCon);
    }
    return Row(
      children: btnCon,
    );
  }
}


