import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
class ComReq{
  // 检查登录状态
  static utilsLoginStatus()async{
    return await HttpUtils.request('/login/status',method: HttpUtils.POST);
  }
  // 获取用户信息
  static Future utilsUserDetail()async{
    return await HttpUtils.request('/user/detail');
  }
  // 退出登录
  static Future utilsLoginOut()async{
    return await HttpUtils.request('/logout');
  }
  static void loginOut()async{
    await SqlLite().open();
    await SqlLite().delLoginInfo();
  }
}
