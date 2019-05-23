import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:ui';

// 加载
Widget loadingWidget() => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Container(
      height: 150.0,
      width: 150.0,
      child: FlareActor(
        R.ASSET_LOADING_FLR,
        animation: "Untitled",
        fit: BoxFit.contain,
        color: C.DEF,
        shouldClip: false,
      ),
    ));
Widget loadingWidgetTwo() => Container(
  height: 120.0,
  width: 120.0,
  child: FlareActor(
    R.ASSET_LOADING_FLR,
    animation: "Untitled",
    fit: BoxFit.contain,
    color: C.DEF,
    shouldClip: false,
  ),
);
// 默认的国旗
Widget flagImage() =>
    Image.asset(
      M.CN,
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
    );

Widget fuToast(msg, defMsg, s, context) =>
    Flushbar(
      messageText: Text(
        msg != null ? s ? msg : msg + "啦 Ծ‸ Ծ" : defMsg,
        style: TextStyle(
            fontSize: 14.0, color: Colors.white, fontFamily: F.Regular),
      ),
      flushbarPosition: FlushbarPosition.TOP,
      //显示位置
      icon: Icon(
        Icons.info_outline,
        size: 30.0,
        color: Colors.white,
      ),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 10,
      duration: Duration(seconds: 4),
      //显示时长
      leftBarIndicatorColor: s ? Colors.green[400] : Colors.red[400],
      backgroundColor: s ? Colors.green[400] : Colors.red[400],
    )..show(context);
