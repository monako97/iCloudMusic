import 'package:dio/dio.dart';
import 'package:icloudmusic/Utils/sqLiteUser.dart';
import 'dart:async';

class HttpUtils {
  static Dio dio;
  /// request method
  static Future<Map<dynamic, dynamic>> request(String url, {data, method}) async {
    data = data ?? {};
    method = method ?? 'get';
    /// restful 请求处理
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });
    print('请求：$method $url ${data.toString()}');

    Dio dio = createInstance();
    var result;
    try {
      Response response;
      if(method=='get'){
        if(url=='https://v1.hitokoto.cn'){
           response = await dio.get(url);
        }else{
          response = await dio.request(url,
              queryParameters: data, options: new Options(method: method));
        }
      }else{
        response = await dio.request(url,
            data: data, options: new Options(method: method));
      }
      result = response.data;
      if(response.statusCode==301){
        print('请登录${response.statusCode}');
      }

    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print("错误类型: ${e}");
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        result = {'msg': '请求超时 Ծ‸ Ծ'};
      } else if (e.type == DioErrorType.DEFAULT) {
        result = {'msg': '服务器好像又死机了耶 Ծ‸ Ծ','code':404};
      } else {
        print("错误: ${e.response.data}");
        if(e.response.statusCode==301){
          final _sqlL = SqlLite();
          await _sqlL.open();
          await _sqlL.delLoginInfo();
        }
        e.response.data==null?result={'msg':'请求超时 Ծ‸ Ծ'}:result=e.response.data;
      }
    }
    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: 'http://103.116.47.219:3000',
        connectTimeout: 10000,
        receiveTimeout: 5000
      );
      dio = new Dio(options);
    }
    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
