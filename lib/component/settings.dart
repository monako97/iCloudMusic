import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS",
            style: TextStyle(
                fontFamily: 'SF-UI-Display-Semibold',
                color: Color.fromRGBO(24, 29, 40, 1),
                fontSize: 18.0)),
        centerTitle: true,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[Text("飒飒差")],
      ),
      backgroundColor: Colors.white,
    );
  }
}
