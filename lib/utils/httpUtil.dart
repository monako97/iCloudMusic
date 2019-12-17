import 'package:dio/dio.dart';
import 'dart:async';
import 'package:icloudmusic/widget/loading.dart';
class HttpUtils {
  static Dio dio;
  static Future request(String url, {data, method,bool load}) async {
    method = method ?? 'get';
    Dio dio = createInstance();
    Response response;
    var result;
    if(method=='get'){
      try{
        response = await dio.request(url,
            queryParameters: data,
            options: new Options(
                method: method,
                extra: {
                  "load": load ?? false
                }
            )
        );
        result = response.data;
      }catch(e){}
    }else{
      try{
        response = await dio.request(url,
            data: data,
            options: new Options(
                method: method,
                extra: {
                  "load": load ?? false
                }
            )
        );
        result = response.data;
      }catch(e){}
    }
    return result;
  }
  // 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: 'http://182.255.33.166:3000',
        connectTimeout: 30000,
        receiveTimeout: 15000
      );
      dio = new Dio(options);
      // 增加拦截器
      dio.interceptors.add(
        InterceptorsWrapper(
          // 接口请求前数据处理
          onRequest: (options) {
            if(options.extra["load"]){
              Loading.before(options.uri);
            }
            print("请求接口 ${options.uri} 显示加载：${options.extra["load"]}");
            return options;
          },
          // 接口成功返回时处理
          onResponse: (Response resp) {
            Loading.complete(resp.request.uri);
            return resp;
          },
          // 接口报错时处理
          onError: (DioError error) {
            print("错误类型：${error.type}");
            print("接口返回错误：${error.response}");
            Loading.complete(error.request.uri);
            switch(error.type){
              case DioErrorType.CONNECT_TIMEOUT:
                Loading.toast("连接超时", false);
                break;
              case DioErrorType.RECEIVE_TIMEOUT:
                Loading.toast("响应超时", false);
                break;
              case DioErrorType.DEFAULT:
                Loading.toast("服务器好像又死机了耶 Ծ‸ Ծ", false);
                break;
              case DioErrorType.RESPONSE:
                print("接口返回错误：${error.response.statusCode}");
                Loading.toast(error.response.data['message']??"好像迷路了 Ծ‸ Ծ", false);
                break;
              default:
                Loading.toast("好像迷路了 Ծ‸ Ծ", false);
                break;
            }
            return error;
          },
        ),
      );
    }
    return dio;
  }
  // 清空 dio 对象
  static clear() {
    dio = null;
  }
}
