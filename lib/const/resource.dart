import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
class R {
  // logo
  static const String ASSET_LOGO_FLR = "assets/flare/test.flr";

  // 消息提醒动画 "Notification Loop"
  static const String ASSET_MSG_FLR = "assets/flare/msg.flr";

  // menu按钮动画 "To Ham" "To Close"
  static const String ASSET_MENU_FLR = "assets/flare/ham2close.flr";

  // 加载动画 "Untitled"
  static const String ASSET_LOADING_FLR = "assets/flare/loading.flr";

  // 播放按钮外的圈圈
  static const String ASSET_COUNTER_FLR = "assets/flare/counter.flr";

  // 播放暂停 "play" "pause"
  static const String ASSET_PLAY_PAUSE_FLR = "assets/flare/playpause.flr";

  // 喜欢动画 "Favorite" "Unfavorite"
  static const String ASSET_LOVE_FLR = "assets/flare/love.flr";

  // 搜索图标
  static const String ASSET_SEARCH_FLR = "assets/flare/search.flr";

  // 笑脸开关
  static const String ASSET_SMILEY_SWITCH_FLR = "assets/flare/SmileySwitch.flr";

  // 收藏动画 "Favourite_star"
  static const String ASSET_STAR_FLR = "assets/flare/star.flr";
}

class F {
  static const String Regular = "SF-UI-Display-Regular";
  static const String Medium = "SF-UI-Display-Medium";
  static const String Semibold = "SF-UI-Display-Semibold";
  static const String Bold = "SF-UI-Display-Bold";
}

class M {
  static const String UN = "assets/images/0.png";
  static const String AURA = "assets/images/aura.png";
  static const String AURA_HOME = "assets/images/aura_home.png";
  static const String BOY = "assets/images/boy.png";
  static const String GIRL = "assets/images/girl.png";
  static const String CN = "assets/images/cn.png";
  static const String FB = "assets/images/facebook.png";
  static const String GG = "assets/images/google.png";
  static const String SP = "assets/images/splash.png";
  static const String VSP = "assets/video/splash.mp4";
}

class C {
  static Color ColorRandom = Color.fromRGBO(Random().nextInt(60) + 180, Random().nextInt(60) + 180,Random().nextInt(60) + 180, 1);
  static const Color DEF = Color.fromRGBO(24, 29, 40, 1);
  static const List<Color> BTN_DEF = [
    Color.fromRGBO(28, 224, 218, 1),
    Color.fromRGBO(71, 157, 228, 1)
  ];
  static const List<List<Color>> WAVE_DEF = [
    [Color.fromRGBO(233, 136, 124, 1), Color.fromRGBO(
        204, 171, 218, 1)
    ],
    [Color.fromRGBO(208, 230, 165, 1), Color.fromRGBO(
        245, 221, 149, 1)
    ],
    [Color.fromRGBO(245, 221, 149, 1), Color.fromRGBO(
        233, 136, 124, 1)
    ],
    [Color.fromRGBO(134, 227, 206, 1), Color.fromRGBO(
        208, 230, 165, 1)
    ]
  ];
  static InputBorder InputBorderNone = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none);
  static InputBorder PhongInputBorde = OutlineInputBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
      borderSide: BorderSide.none);
  static List<BoxShadow> BTN_SHADOW = [
    BoxShadow(
      color: Color.fromRGBO(159, 210, 243, 0.35),
      blurRadius: 24.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 12.0),
    )
  ];
  static List<BoxShadow> CD_SHADOW = [
    BoxShadow(
      color: Color.fromRGBO(192, 193, 193, 0.35),
      blurRadius: 15.0,
      spreadRadius: 4.0,
      offset: Offset(0.0, 0.0),
    ),
  ];
  static List<BoxShadow> CON_SHADOW = [
    BoxShadow(
      color: Color.fromRGBO(60, 31, 77, 0.1),
      blurRadius: 10.0,
      spreadRadius: 8.0,
      offset: Offset(0.0, 20.0),
    ),
  ];
}

class D {
  // 获取状态栏高度
  static double topPadding = MediaQueryData.fromWindow(window).padding.top;
  // 屏幕宽度
  static double SWidth = MediaQueryData.fromWindow(window).size.width;
}