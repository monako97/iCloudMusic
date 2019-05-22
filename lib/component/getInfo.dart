import 'package:icloudmusic/Utils/HttpUtil.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:icloudmusic/Utils/listData.dart';
import 'dart:io';
class H {
  static final sqlListData = SqlListData();
  static final sqlLite = SqlLite();
  // 一言
  static Future<Map<String, dynamic>> hit()async{
    List<Map<dynamic, dynamic>> _hitLists;
    Map<String, dynamic> _hits = await HttpUtils.request('https://v1.hitokoto.cn');
    if(_hits['hitokoto']!=null){
        // 将获取到的一言存入数据
        await sqlListData.open();
        await sqlListData.insertHit(_hits);
        // 取出数据
        _hitLists = await sqlListData.queryForm('hitokoto');
    }
    return _hitLists[_hitLists.length-1];
  }
  // 缓存的用户信息
  static Future<Map<String, dynamic>> queryUserInIf()async{
    await sqlLite.open();
    List<Map<String,dynamic>> _u = await sqlLite.queryUserInfo();
    return _u[0];
  }
  // 检查登录状态
  static Future<Map<String,dynamic>> loginStatus()async{
    return await HttpUtils.request('/login/status',method: 'post');
  }
  // 检查登录状态
  static Future<Map<String,dynamic>> loginOut()async{
    return await HttpUtils.request('/logout',method: 'post');
  }
  // 用户详情
  static Future<Map<String, dynamic>> getUserDetail()async{
    Map<String, dynamic> detail = await queryUserInIf();
    int ids = detail['userId'];
    detail = await HttpUtils.request('/user/detail',data: {'uid':ids});
    return detail;
  }
  // 用户信息 , 歌单，收藏，mv, dj 数量
  static Future<Map<String, dynamic>> getSubCount()async{
    return await HttpUtils.request('/user/subcount');
  }
  /// home
  /// banner
  static Future<List<Map<String, dynamic>>> getBanners() async {
    int device;
    if (Platform.isIOS) {//ios
      device = 2;
    } else if (Platform.isAndroid) {//android
      device = 1;
    } else {
      device = 0;
    }
    // 从服务端获取banner
    Map<String, dynamic> _banner = await HttpUtils.request('/banner',data: {"type": device});
    if (_banner['code'] == 200) {
      await sqlListData.delForm("banner");
      _banner['banners'].forEach((e) async {
        await sqlListData.insertForm("banner", e);
      });
    } else {
      print("获取banner数据失败");
    }
    return await sqlListData.queryForm("banner");
  }
}