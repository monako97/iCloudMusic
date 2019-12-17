import 'package:flutter/material.dart';
import 'package:xlive_switch/xlive_switch.dart';
class RememberMe extends StatefulWidget{
  final setRemember;
  RememberMe({Key key,@required this.setRemember}) : super(key : key);
  @override
  _RememberMe createState() => _RememberMe();
}
class _RememberMe extends State<RememberMe>{
  bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.0,
      child: Row(
        children: <Widget>[
          XlivSwitch(
            value: _rememberMe,
            onChanged: (e) {
              _rememberMe = e;
              widget.setRemember(e);
              setState(() => {});
            },
          ),
          Text(
            "  Remember me?",
            style: TextStyle(
                color: Color.fromRGBO(24, 29, 40, 1),
                fontSize: 16.0,
                fontFamily: "SF-UI-Display-Medium"),
          )
        ],
      ),
    );
  }
}