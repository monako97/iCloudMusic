import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';

Set dict = Set();
bool loadingStatus = false;

// 加载
class Loading {
  static dynamic context;

  static void before(uri) {
    dict.add(uri); // 放入set变量中
    // 已有弹窗，则不再显示弹窗, dict.length >= 2 保证了有一个执行弹窗即可，
    if (loadingStatus == true || dict.length >= 2) {
      return;
    }
    loadingStatus = true; // 修改状态
    // 显示弹窗
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // 用Scaffold返回显示的内容，能跟随主题
        return LoadingWidget();
      },
    );
  }

  static void complete(uri) {
    dict.remove(uri);
    // 所有接口接口返回并有弹窗
    if (dict.length == 0 && loadingStatus == true) {
      loadingStatus = false; // 修改状态
      // 完成后关闭loading窗口
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static Widget toast(String message, bool state) {
    return Flushbar(
      messageText: Text(
        message,
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontFamily: "SF-UI-Display-Regular"),
      ),
      flushbarPosition: FlushbarPosition.TOP,
      //显示位置
      icon: Icon(
        Icons.info_outline,
        size: 30.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      duration: Duration(seconds: 4),
      //显示时长
      leftBarIndicatorColor: state ? Colors.green[400] : Colors.red[400],
      backgroundColor: state ? Colors.green[400] : Colors.red[400],
    )..show(context);
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                  width: 150.0,
                  height: 150.0,
                  color: Colors.white12,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      FlareActor(
                        "assets/flare/loading.flr", // flr文件
                        animation: "Untitled", // 动画名称
                        fit: BoxFit.contain,
                        color: Color.fromRGBO(24, 29, 40, 1),
                        shouldClip: false,
                      ),
                      Positioned(
                        bottom: 15.0,
                        child: Text("加载中..."),
                      )
                    ],
                  ))),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
