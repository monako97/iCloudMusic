import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
class H {
  static final sqlLite = SqlLite();
  // 一言
  static Future<Map<String, dynamic>> hit()async{
    List<Map<dynamic, dynamic>> _hitLists;
    Map<String, dynamic> _hits = await HttpUtils.request('https://v1.hitokoto.cn');
    if(_hits['hitokoto']!=null){
        // 将获取到的一言存入数据
        await sqlLite.open();
        await sqlLite.insertHit(_hits);
        // 取出数据
        _hitLists = await sqlLite.queryForm('hitokoto');
    }
    return _hitLists[_hitLists.length-1];
  }

  /// 登录
  // 手机号码登录
  static Future<Map<String,dynamic>> loginPhone(Map<String,dynamic> d,bool t)async{
    Map<String,dynamic> res = await HttpUtils.request('/login/cellphone',data: d);
    if (res != null && res['code'] == 200) {
      await sqlLite.open();
      // 登录成功，保存数据 登录的账号信息记录一下
      await sqlLite.insertLoginInfo(res['profile'], d, t);
      // 登录成功跳转页面 并且关闭给定路由的之前的所有页面
      List<Map<String,dynamic>> l = await sqlLite.queryLogin();
      res =l[0];
    }
    return res;
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
  // 登出
//  static Future loginOut(BuildContext context)async{
//    await HttpUtils.request('/logout',method: 'post').then((e) async {
//      if (e['code'] == 200) {
//        await sqlLite.open();
//        await sqlLite.delLoginInfo();
//        Navigator.pushNamedAndRemoveUntil(context, '/start', (route) => route == null);
//      } else {
//        messageBar(e['msg'], "服务器有点挤 Ծ‸ Ծ 等一下再来叭", false, context);
//      }
//    });
//  }
  // 用户详情
  static Future<Map<String, dynamic>> getUserDetail()async{
    Map<String, dynamic> detail = await queryUserInIf();
    int ids = detail['userId'];
    detail = await HttpUtils.request('/user/detail',data: {'uid':ids});
    return detail;
  }
  // 用户信息 , 歌单，收藏，mv, dj 数量
  static Future<Map<String, dynamic>> getSubCount()async{
    print(await HttpUtils.request('/user/subcount'));
    return await HttpUtils.request('/user/subcount');
  }
  /// home
  ///
  // 搜索
  static Future<Map<String,dynamic>> searchSong(String song,BuildContext context) async {
    Map<String,dynamic> res = await HttpUtils.request('/search', data:{"keywords" : song});
    if(res['code']!=200){
//      messageBar(res['msg'], "服务器有点挤 Ծ‸ Ծ 等一下再来叭", false, context);
    }
    return res;
  }
  // 搜索建议
  static Future<Map<String,dynamic>> searchSuggest(String song) async {
    if(song.trim().length<=0){
      return {};
    }
    Map<String,dynamic> res = await HttpUtils.request('/search/suggest', data:{"keywords" : song});
    return res;
  }
}