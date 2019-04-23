import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; //视频播放插件

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  VideoPlayerController _controller;
  String url = 'assets/video/splash1.mp4';
  @override
  void initState() {
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
    return Scaffold(
        body: Center(
            child: Stack(
      children: <Widget>[
        _controller.value.initialized
            // 加载成功
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Image.asset(
                "assets/images/splash1.png",
                fit: BoxFit.cover,
              ),
        Container(
          alignment: Alignment.center,
          child: Text("引导页"),
        ),
        Positioned(
          bottom: 40.0,
          left: 20.0,
          right: 20.0,
          child: RaisedButton(
            child: Text("我有账号",style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w500
            ),),
          ),
        ),
        Positioned(
          bottom: 90.0,
          left: 20.0,
          right: 20.0,
          child: RaisedButton(
            child: Text("创建账号",style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500
            ),),
          ),
        ),

      ],
    )));
  }
}
