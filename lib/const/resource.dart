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

  // add "Collapse" "Expand"
  static const String ASSET_ADD_FLR = "assets/flare/add.flr";
}

class F {
  static const String Regular = "SF-UI-Display-Regular";
  static const String Medium = "SF-UI-Display-Medium";
  static const String SemiBold = "SF-UI-Display-Semibold";
  static const String Bold = "SF-UI-Display-Bold";
  static const String Ultralight = "SF-UI-Display-Ultralight";
  static const String Thin = "SF-UI-Display-Thin";
  static const String Light = "SF-UI-Display-Light";
  static const String Heavy = "SF-UI-Display-Heavy";
  static const String Black = "SF-UI-Display-Black";
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
  // cd
  static const String CD1 = "assets/images/cd1.png";
  static const String CD2 = "assets/images/cd2.png";
  static const String CD3 = "assets/images/cd3.png";
  static const String CD4 = "assets/images/cd4.png";
  static const String CD5 = "assets/images/cd5.png";
  static const String CD6 = "assets/images/cd6.png";
  static const String CD7 = "assets/images/cd7.png";
  static const String CD8 = "assets/images/cd8.png";
  static const String CD9 = "assets/images/cd9.png";
  static const String CD10 = "assets/images/cd10.png";
  static const String PLAYLIST1 = "assets/images/playlists1.png";
  static const String PLAYLIST2 = "assets/images/playlists2.png";
  static const String PLAYLIST3 = "assets/images/playlists3.png";
  static const String PLAYLIST4 = "assets/images/playlists4.png";
  // type
  static const String OO = "assets/images/00.png";
  static const String O8 = "assets/images/80.png";
  static const String O9 = "assets/images/90.png";
  static const String alternative = "assets/images/alternative.png";
  static const String background = "assets/images/background.png";
  static const String classic = "assets/images/classic.png";
  static const String dance = "assets/images/dance.png";
  static const String energetic = "assets/images/energetic.png";
  static const String ETERNAL = "assets/images/eternalhits.png";
  static const String GENRE = "assets/images/genreday.png";
  static const String love = "assets/images/love.png";
  static const String metal = "assets/images/metal.png";
  static const String party = "assets/images/party.png";
  static const String pop = "assets/images/pop.png";
  static const String rap = "assets/images/rap.png";
  static const String relax = "assets/images/relax.png";
  static const String road = "assets/images/road.png";
  static const String rock = "assets/images/rock.png";
  static const String run = "assets/images/run.png";
  static const String sad = "assets/images/sad.png";
  static const String sleep = "assets/images/sleep.png";
  static const String soul = "assets/images/soul.png";
  static const String soundtrack = "assets/images/soundtrack.png";
  static const String sport = "assets/images/sport.png";
  static const String spring = "assets/images/spring.png";
  static const String trend = "assets/images/trend.png";
  // splash
  static const String SP = "assets/images/splash.png";
  static const String VSP = "assets/video/splash.mp4";
}

class C {
  static Color colorRandom = Color.fromRGBO(Random().nextInt(60) + 180, Random().nextInt(60) + 180,Random().nextInt(60) + 180, 1);
  static const Color DEF = Color.fromRGBO(24, 29, 40, 1);
  static const Color DEFT = Color.fromRGBO(24, 29, 40, 0.87);
  static const Color OPACITY_DEF = Color.fromRGBO(150, 150, 150, 0.1);
  static const Color RED = Colors.red;
  static const List<Color> BTN_DEF = [Color.fromRGBO(28, 224, 218, 1), Color.fromRGBO(71, 157, 228, 1)];
  static const List<List<Color>> WAVE_DEF = [[Color.fromRGBO(233, 136, 124, 1), Color.fromRGBO(204, 171, 218, 1)],[Color.fromRGBO(208, 230, 165, 1), Color.fromRGBO(245, 221, 149, 1)], [Color.fromRGBO(245, 221, 149, 1), Color.fromRGBO(233, 136, 124, 1)], [Color.fromRGBO(134, 227, 206, 1), Color.fromRGBO(208, 230, 165, 1)]];
  static InputBorder inputBorderNone = OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none);
  static InputBorder phoneInputBorder = OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)), borderSide: BorderSide.none);
  static List<BoxShadow> btnShadow = [BoxShadow(color: Color.fromRGBO(159, 210, 243, 0.35), blurRadius: 24.0, spreadRadius: 0.0, offset: Offset(0.0, 12.0),)];
  static List<BoxShadow> cdShadow = [BoxShadow(color: Color.fromRGBO(192, 193, 193, 0.35), blurRadius: 15.0, spreadRadius: 4.0, offset: Offset(0.0, 0.0)),];
  static List<BoxShadow> cdLShadow = <BoxShadow>[BoxShadow(color: Color.fromRGBO(112, 112, 112, 0.15), blurRadius: 15.0,offset: Offset(0.0, 5.0))];
  static List<List<BoxShadow>> list5BoxShadow = [<BoxShadow>[BoxShadow(
        color: Color.fromRGBO(248, 53, 73, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )],<BoxShadow>[BoxShadow(
        color: Color.fromRGBO(20, 26, 30, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )],<BoxShadow>[BoxShadow(
        color: Color.fromRGBO(122, 43, 60, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )],<BoxShadow>[BoxShadow(
        color: Color.fromRGBO(49, 208, 190, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )],<BoxShadow>[BoxShadow(
        color: Color.fromRGBO(174, 135, 146, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )]];
  static const List<Color> PLAYLISTColor = [Color.fromRGBO(18, 29, 46, 0.35), Color.fromRGBO(12, 71, 202, 0.35), Color.fromRGBO(123, 170, 202, 0.35), Color.fromRGBO(10, 46, 59, 0.35)];
}

class D {
  // 获取状态栏高度
  static double topPadding = MediaQueryData.fromWindow(window).padding.top;
  // 屏幕宽度
  static double sWidth = MediaQueryData.fromWindow(window).size.width;
  // 屏幕高度
  static double sHeight = MediaQueryData.fromWindow(window).size.height;
}
MaterialColor colorString(str){
  switch(str){
    case 'red':
      return Colors.red;
      break;
    case 'blue':
      return Colors.blue;
      break;
    case 'yellow':
      return Colors.yellow;
      break;
    case 'pink':
      return Colors.pink;
      break;
    default:
      return Colors.white;
      break;
  }
}