import 'package:flutter/material.dart';
import 'dart:math';

class LogoStack extends StatefulWidget {
  @override
  _LogoStackState createState() => _LogoStackState();
}

class _LogoStackState extends State<LogoStack> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final List<Map<String, dynamic>> logoConfig = <Map<String, dynamic>>[{
      "Color": [Color.fromRGBO(100, 107, 152, 1), Color.fromRGBO(94, 43, 103, 1)],
      "opacity": 0.3,
      "top": 13.75,
      "left": 21.23
    }, {
      "Color": [Color.fromRGBO(91, 63, 232, 1), Color.fromRGBO(61, 119, 244, 1)],
      "opacity": 0.2,
      "top": 27.52,
      "left": 28.07
    }, {
      "Color": [Color.fromRGBO(59, 181, 182, 1), Color.fromRGBO(66, 226, 151, 1)],
      "opacity": 0.6,
      "top": 30.15,
      "left": 21.59
    }, {
      "Color": [Color.fromRGBO(28, 224, 218, 1), Color.fromRGBO(71, 157, 228, 1)],
      "opacity": 0.6,
      "top": 24.14,
      "left": 16.19
    }, {
      "Color": [Color.fromRGBO(87, 45, 127, 1), Color.fromRGBO(33, 188, 212, 1)],
      "opacity": 0.6,
      "top": 18.61,
      "left": 29.77,
    }];

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(seconds: 5),
        vsync: this
    );
    _controller.repeat();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> paoPao = new List();
    for (int i = logoConfig.length - 1; i >= 0; i--) {
      Widget item = Positioned(
        top: logoConfig[i]['top'],
        left: logoConfig[i]['left'],
        child: Opacity(
            opacity: logoConfig[i]['opacity'],
            child:
          AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform.rotate(
                        angle: _controller.value * 2 * pi * i,
                        child: child
                    );
                  },
                  child: Transform.rotate(
                      angle: _controller.value * pi / 4.0,
                    child: Container(
                      width: 88.41,
                      height: 88.41,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: logoConfig[i]['Color']),
                          borderRadius: BorderRadius.circular(60.41)
                      ),
                    ),
                  )
                  ),
            )
      );
      paoPao.add(item);
    }
    paoPao.add(Container(
      width: 70.41,
      height: 70.41,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(88.41)),
    ));
    return Container(
      width: 134.37,
      height: 134.37,
      child: Stack(
        alignment: Alignment.center,
        children: paoPao,
      )
    );
  }
}




