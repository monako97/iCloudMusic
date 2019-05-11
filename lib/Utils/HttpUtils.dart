import 'package:dio/dio.dart';
import 'dart:async';

class HttpUtils {
  static Dio dio;

  /// default options
  static const String API_PREFIX = 'http://103.116.47.219:3000';
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 5000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// request method
  static Future<Map> request(String url, {data, method}) async {
    data = data ?? {};
    method = method ?? 'GET';

    /// restful 请求处理
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    print('请求地址：【' + method + '  ' + url + '】');
    print('请求参数：' + data.toString());
    Dio dio = createInstance();
    var result;

    try {
      dio.interceptor.request.onSend = (Options options) {
        // 在请求被发送之前做一些事情
        return options; //continue
      };
      Response response = await dio.request(url,
          data: data, options: new Options(method: method));
      result = response.data;
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print("错误类型: ${e}");
      print("错误类型: ${e.type}");
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        print(e.message);
        result = {'msg': '请求超时 Ծ‸ Ծ'};
      } else if (e.type == DioErrorType.DEFAULT) {
        result = {'msg': '服务器好像又死机了耶 Ծ‸ Ծ'};
      } else {
        //        e.response==null?result={'msg':'请求超时'}:result=e.response.data;
        result = e.response.data;
      }
    }

//    try {
//      Response response = await dio.request(url, data: data, options: new Options(method: method));
//      result = response.data;
//    } on Options catch (options) {
//      //请求之前
//      print("请求之前: $options");
//    } on DioError catch (e) {
//      /// 打印请求失败相关信息
//      print("错误类型: ${e.type}");
//      if(e.type==DioErrorType.CONNECT_TIMEOUT||e.type==DioErrorType.RECEIVE_TIMEOUT){
//        result={'msg':'请求超时'};
//      }else{
////        e.response==null?result={'msg':'请求超时'}:result=e.response.data;
//        result=e.response.data;
//      }
//    }
    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      Options options = new Options(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
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
