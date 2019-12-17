import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
class PlaySound {
  static String uri;
  static String state = "stop"; // 播放状态 play pause stop
  static FlutterSound flutterSound = new FlutterSound(); //创建一个播放实例
  static StreamSubscription playerSubscription; //监听播放
  static double value = 0.0; //播放位置
  static double maxDuration = 1.0; //时长
  //停止播放
  static stop() async {
    state =  "stop";
    value = 0.0;
    try{
      await flutterSound.stopPlayer();
      // 清除监听
      playerSubscription?.cancel();
    }catch(e){}
    playerSubscription = null;
  }
  static play(url, callback) async {
    print(state);
    switch(state){
      case "stop":
        startPlay(url, callback);
        break;
      case "play":
        pause(callback);
        break;
      case "pause":
        resume(callback);
        break;
      default:
        break;
    }
  }
  static startPlay(String url, callback) async {
    if(url != null) uri = url;
    if(uri != null){
      // 如果在播放，则先停止播放
      if(flutterSound.isPlaying){
        stop();
      }
      // 开始播放
      await flutterSound.startPlayer(uri);
      state =  "play";
      // 监听播放
      playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          // 音频时长
          maxDuration = e.duration;
          // 播放位置
          value = e.currentPosition;
          if(e.currentPosition >= (e.duration - 1)){
            stop(); // 播放完成释放资源
//            state =  "stop";
          }
          try{
            callback(state, value, maxDuration);
          }catch(e){

          }
        }
      });
    }
  }
  // 恢复播放
  static resume(callback) async {
    if(flutterSound.isPlaying){
      print("播放: $uri");
      await flutterSound.resumePlayer();
      state =  "play";
      try{
        callback(state,null,null);
      }catch(e){

      }
    }
  }
  // 暂停播放
  static pause(callback) async {
    // 检测是否有播放实例
    if(flutterSound.isPlaying) {
      print("暂停: $uri");
      await flutterSound.pausePlayer();
      state =  "pause";
      try{
        callback(state,null,null);
      }catch(e){

      }

    }
  }
  // 定位播放
  static seek(int value) async {
    if(flutterSound.isPlaying){
      state =  "play";
      await flutterSound.seekToPlayer(value);
    }
  }
}
class ValueNotifierData extends ValueNotifier<dynamic> {
  ValueNotifierData(value) : super(value);
}