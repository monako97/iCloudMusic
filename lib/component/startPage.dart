import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; //视频播放插件
import 'package:flutter_swiper/flutter_swiper.dart'; //轮播
import 'package:icloudmusic/component/login.dart';
import 'package:icloudmusic/component/registration.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui';
class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  VideoPlayerController _controller;

  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.asset(M.VSP)
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
  dispose() {
    _controller.dispose();
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
              _controller.value.initialized
              // 加载成功
                  ? VideoPlayer(_controller)
                  : Image.asset(M.SP,
                fit: BoxFit.cover,
              ),
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
                          "${SwiperText[index]}",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: F.Regular),
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
                    Colors.white, false, ["I have an account. ", "ENTER"],
                    true, _controller),
              ),
              Positioned(
                  bottom: 130.0,
                  left: 25.0,
                  right: 25.0,
                  height: 60.0,
                  child: Hero(
                    tag: 'LOGIN',
                    child: BlockLevelButton(Colors.transparent, true, [
                      "I'M A NEW USER"
                    ], false, _controller),
                  )
              ),
            ],
          )),
    );
  }
}

class BlockLevelButton extends StatelessWidget {
  bool isBgColor;
  final BorderColors; // 边框色
  List TextCon; // 按钮内容
  bool routeName; //路由
  final _controller;

  BlockLevelButton(this.BorderColors, this.isBgColor, this.TextCon,
      this.routeName, this._controller);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, FadeRoute((this.routeName ? Login() : Registration())))
              .then((res) {
            //获取返回处理
            _controller.play();
          });
          _controller.pause();
        },
        splashColor: Color.fromRGBO(28, 224, 218, 0.54),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: this.BorderColors,
              ),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: C.btnShadow,
              gradient: this.isBgColor
                  ? LinearGradient(colors: C.BTN_DEF)
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
              fontFamily: F.Regular));
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
