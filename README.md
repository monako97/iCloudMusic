# iCloudMusic
> #### 总觉得该说点啥   
+      最近开始学习Flutter 

       但是呢，光看光写点样例呢，总感觉不太稳
       
       《iCloudMusic》是萌新使用 Flutter 开发的一款第三方网易云音乐播放器
> #### 已完成的部分

> <img src="https://i.loli.net/2019/05/15/5cdb72077ad8173418.png" width="250" div align="center" /><img src="https://i.loli.net/2019/05/15/5cdb7008a725524808.png" width="250" div align="center" /><img src="https://i.loli.net/2019/05/15/5cdb70c14fc8674746.png" width="250" div align="center" /><img src="https://i.loli.net/2019/05/15/5cdb7083b853188378.png" width="250" div align="center" /><img src="https://i.loli.net/2019/05/15/5cdb711c603b773473.png" width="250" div align="center" /><img src="https://i.loli.net/2019/05/15/5cdb7153eb5dd27919.png" width="250" div align="center" />
  
> #### 构建项目
+     flutter create 项目名称  
      -t      =>    项目类型 
      --org   =>    bundle identifier
      -i      =>    IOS开发语言  
      -a      =>    Android开发语言
      flutter create -t app --org com.monako -i swift -a kotlin icloudmusic 
> #### 使用<a href="https://console.firebase.google.com/">FireBase</a>
>     IOS:
>     1、使用 PRODUCT_BUNDLE_IDENTIFIER 前往FireBase官网注册应用
>     2、按步骤完成操作，下载 GoogleService-Info.plist 并用xcode添加至Runner工程目录下

>     ANDROID:
>     1、使用 PRODUCT_BUNDLE_IDENTIFIER 前往FireBase官网注册应用
>     2、按步骤完成操作，下载 google-services.json 并添加至app工程目录下
>     3、开启项目根目录下的 build.gradle 
>        在 buildscript > dependencies > 
>        添加：classpath 'com.google.gms google-services:3.2.1'
>     4、开启项目app工程目录下的 build.gradle 
>        在末尾添加：apply plugin: 'com.google.gms.google-services'
> #####配置完成后添加: <a href="https://pub.dev/packages/firebase_messaging/">firebase_messaging</a>

> #### 构建页面
+ 欢迎页/引导页   
>     首次开启app，将会会跳转到欢迎页面
>
>     使用video_player完成视频背景widget
>
>     使用Stack层叠布局，将视频作为背景，并循环自动播放
>
>     离开欢迎页面时需要释放播放器资源

+     initialize() - 初始化播放器
      dispose() - 释放播放器资源
      notifyListeners() - 监听播放消息   
      addListener(listener) - 添加监听器   
      removeListener(listener) - 移除监听器  
      pause() - 暂停播放   
      play() - 开始播放   
      position - 播放位置   
      seekTo(moment) - 指定到某个位置播放  
      setLooping(looping) - 是否循环播放   
      setVolume(volume) - 设置音量大小
>     使用flutter_swiper组件完成欢迎页的轮播widget
>     
>     添加注册及登录跳转button      

+  #### 设置状态栏文字颜色
    + 引入依赖: 
         + import 'package:flutter/services.dart';
         + import 'dart:io';
         
    + 构建方法中：
    +     if (Platform.isAndroid) {
              // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
              SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
              SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
          }else{
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          }
>   #### 登录/注册

>      1、使用 GestureDetector 做主容器，实现点击表单外部时，收起软键盘
>      2、根据用户选择是否记录登录过的账号，以便下次快速登录（模仿qq选择账号）
>      3、判断该账号是否为首次使用该程序，首次使用则跳转用户引导页

>   #### 引导页

>      1、使用Hero的飞入动画跳转页面
>      2、引导完成跳转路由之前，修改首次使用状态，下次登录账号直接跳转主页面
>      3、音乐视图支持滑动唱片切歌，定位播放位置、喜欢等

>   #### Drawer(删除)
>      1、自动获取背景图并设置为抽屉列表背景
>      2、头部显示用户基本信息，点击头像跳转详情信息
>      3、将退出按钮置于底部

>   #### Home(改用cupertino套件，为了他的动态模糊标题栏哈哈哈)
>      1、标题栏为drawer开关，头像，message提示图标
>      2、头部显示banner，根据其banner属性判断跳转的router并执行其功能(NativeWeb组件添加一个返回的float按钮)