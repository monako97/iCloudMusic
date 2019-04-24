import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; //视频播放插件
import 'package:flutter_swiper/flutter_swiper.dart'; //轮播
import 'package:flutter/services.dart';
import 'dart:io';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  VideoPlayerController _controller;
  String url = 'assets/video/splash.mp4';

  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.asset(this.url)
    // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {
          // 视频为播放状态
          _controller.play();
          // 循环播放
          _controller.setLooping(true);
        });
      });
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
                _controller.value.initialized
                // 加载成功
                    ? VideoPlayer(_controller)
                    : Image.asset(
                  "assets/images/splash.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 230.0,
                  left: 25.0,
                  right: 25.0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            "${SwiperText[index]}",
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
                      itemCount: SwiperText.length,
                      pagination: SwiperPagination(),
                    ),
                  ),
                ),
                // 按钮
                Positioned(
                  bottom: 50.0,
                  left: 25.0,
                  right: 25.0,
                  height: 60.0,
                  child: BlockLevelButton(
                      Colors.white, false, [], ["I have an account. ", "ENTER"],
                      '/registration'),
                ),
                Positioned(
                  bottom: 130.0,
                  left: 25.0,
                  right: 25.0,
                  height: 60.0,
                  child: BlockLevelButton(Colors.transparent, true, [
                    Color.fromRGBO(28, 224, 218, 1),
                    Color.fromRGBO(71, 157, 228, 1)
                  ], [
                    "I'M A NEW USER"
                  ], '/login'),
                ),
              ],
            )));
  }
}

class BlockLevelButton extends StatelessWidget {
  var BackgroundColor; // 背景色
  bool isBgColor;
  final BorderColors; // 边框色
  List TextCon; // 按钮内容
  String routeName; //路由
  BlockLevelButton(this.BorderColors, this.isBgColor, this.BackgroundColor,
      this.TextCon, this.routeName);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, this.routeName);
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: this.BorderColors,
              ),
              borderRadius: BorderRadius.circular(8.0),
              gradient: this.isBgColor
                  ? LinearGradient(colors: BackgroundColor)
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ButtonContext(this.TextCon)],
          ),
        ),
      ),
    );
  }
}

// 按钮内容文字
class ButtonContext extends StatelessWidget {
  List TextCon;
  List<Widget> BtnCon = new List();
  var TextColors;

  ButtonContext(this.TextCon);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < this.TextCon.length; i++) {
      if (this.TextCon.length > 1) {
        i == 0 ? TextColors = Colors.white70 : TextColors = Colors.white;
      } else {
        TextColors = Colors.white;
      }
      var itemCon = Text(this.TextCon[i],
          style: TextStyle(
              color: TextColors,
              fontSize: 18.0,
              fontFamily: "SF-UI-Display-Regular"));
      BtnCon.add(itemCon);
    }
    return Row(
      children: BtnCon,
    );
  }
}

List<String> SwiperText = [
  "Millions of tracks",
  "Playlists for any mood",
  "New music every day",
  "Ability to download tracks",
  "High sound quality"
];
