import 'dart:ui';
import 'package:flutter/material.dart';
class DeviceInfo {
  // 获取状态栏高度
  static double padding = MediaQueryData.fromWindow(window).padding.top;
  // 屏幕宽度
  static double width = MediaQueryData.fromWindow(window).size.width;
  // 屏幕高度
  static double height = MediaQueryData.fromWindow(window).size.height;
}