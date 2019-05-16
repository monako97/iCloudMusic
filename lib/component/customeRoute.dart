import 'package:flutter/material.dart';

// 缩放渐变
class FadeRoute extends PageRouteBuilder {
  final Widget widget;

  FadeRoute(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 200), //动画时间为200毫秒
            pageBuilder: (
              //需要传递三个参数
              BuildContext context, //上下文
              Animation<double> animation1, //动画
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: ( //需要接收四个参数
                BuildContext context, //上下文
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              // 渐变路由效果
              return FadeTransition(
                opacity: Tween(
                        begin: 0.0, //开始透明度
                        end: 1.0 //结束透明度
                        )
                    .animate(CurvedAnimation(
                        parent: animation1, curve: Curves.linear //动画曲线
                        )),
                child: child,
              );
            });
}

// 缩放渐变
class ScaleFade extends PageRouteBuilder {
  final Widget widget;

  ScaleFade(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 200), //动画时间为500毫秒
            pageBuilder: (
              //需要传递三个参数
              BuildContext context, //上下文
              Animation<double> animation1, //动画
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: ( //需要接收四个参数
                BuildContext context, //上下文
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              // 缩放路由效果
              return ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(parent: animation1, curve: Curves.linear)),
                child: FadeTransition(
                  opacity: Tween(
                          begin: 0.0, //开始透明度
                          end: 1.0 //结束透明度
                          )
                      .animate(CurvedAnimation(
                          parent: animation1, curve: Curves.linear //动画曲线
                          )),
                  child: child,
                ),
              );
            });
}

// 旋转渐变路由动画
class RoFade extends PageRouteBuilder {
  final Widget widget;

  RoFade(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 200), //过度时间
            pageBuilder: (
              //需要传递三个参数
              BuildContext context, //上下文
              Animation<double> animation1, //动画
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: ( //需要接收四个参数
                BuildContext context, //上下文
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              // 旋转缩放路由动画
              return RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animation1, curve: Curves.fastOutSlowIn)),
                child: FadeTransition(
                  opacity: Tween(
                          begin: 0.0, //开始透明度
                          end: 1.0 //结束透明度
                          )
                      .animate(CurvedAnimation(
                          parent: animation1, curve: Curves.fastOutSlowIn //动画曲线
                          )),
                  child: child,
                ),
              );
            });
}
