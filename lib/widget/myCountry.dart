import 'package:flutter/material.dart';
// 默认的guo国旗
class MyCountry extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/cn.png",
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
    );
  }
}