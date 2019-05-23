import 'package:flutter/material.dart';
import 'dart:math';

class LogoStack extends StatefulWidget {
  @override
  _LogoStackState createState() => _LogoStackState();
}

class _LogoStackState extends State<LogoStack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134.37,
      height: 134.37,
      child: logoStack(),
    );
  }
}

Widget logoStack() {
  List<Widget> paoPao = new List();
  for (int i = logoConfig.length - 1; i >= 0; i--) {
    Widget item = Positioned(
      top: logoConfig[i]['top'],
      left: logoConfig[i]['left'],
      child: Opacity(
          opacity: logoConfig[i]['opacity'],
          child: Transform.rotate(
            child: Container(
              width: 88.41,
              height: 88.41,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: logoConfig[i]['Color']),
                  borderRadius: BorderRadius.circular(88.41)),
            ),
            angle: pi / 4.0,
          )),
    );
    paoPao.add(item);
  }
  paoPao.add(Container(
    width: 88.41,
    height: 88.41,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(88.41)),
  ));
  return Stack(
    alignment: Alignment.center,
    children: paoPao,
  );
}

List<Map<String, dynamic>> logoConfig = [
  {
    "Color": [Color.fromRGBO(100, 107, 152, 1), Color.fromRGBO(94, 43, 103, 1)],
    "opacity": 0.3,
    "top": 13.75,
    "left": 21.23
  },
  {
    "Color": [Color.fromRGBO(91, 63, 232, 1), Color.fromRGBO(61, 119, 244, 1)],
    "opacity": 0.2,
    "top": 27.52,
    "left": 28.07
  },
  {
    "Color": [Color.fromRGBO(59, 181, 182, 1), Color.fromRGBO(66, 226, 151, 1)],
    "opacity": 0.6,
    "top": 30.15,
    "left": 21.59
  },
  {
    "Color": [Color.fromRGBO(28, 224, 218, 1), Color.fromRGBO(71, 157, 228, 1)],
    "opacity": 0.6,
    "top": 24.14,
    "left": 16.19
  },
  {
    "Color": [Color.fromRGBO(87, 45, 127, 1), Color.fromRGBO(33, 188, 212, 1)],
    "opacity": 0.6,
    "top": 18.61,
    "left": 29.77,
  }
];
