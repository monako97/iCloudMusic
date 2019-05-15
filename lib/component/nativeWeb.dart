import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
// 屏幕宽度
double sHeight = MediaQueryData
    .fromWindow(window)
    .size
    .height;
class NativeWebView extends StatefulWidget {
  // 接受路由传递的url
  final String urls;
  NativeWebView({Key key,@required this.urls}) : super(key: key);
  @override
  _NativeWebViewState createState() => _NativeWebViewState();
}
class _NativeWebViewState extends State<NativeWebView> {
  // 声明一个web控制器
  WebController webController;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    FlutterNativeWeb flutterWebView = FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
              () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );
    return Scaffold(
      body: Container(
          child: flutterWebView,
          height: sHeight
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context,(route) => route == null);
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.keyboard_arrow_left),
      ),
    );
  }
  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl(widget.urls);
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }

}
