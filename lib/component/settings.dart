import 'package:flutter/material.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
import 'package:icloudmusic/widget/loading.dart';
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final sqlLite = SqlLite();
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  Widget build(BuildContext context) {
    Loading.context = context;
    return Scaffold(
      appBar:AppBar(
        title: Text("SETTINGS",
            style: TextStyle(
                fontFamily: "SF-UI-Display-Semibold",
                color: Color.fromRGBO(24, 29, 40, 1),
                fontSize: 18.0)
        ),
        centerTitle: true,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Color.fromRGBO(24, 29, 40, 1)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: DeviceInfo.padding+48),
              child: Text("SETTINGS"),
            ),
            GestureDetector(
              onTap: ()async{
                await HttpUtils.request('/logout',method: 'post').then((e) async {
                  print(e);
                  if (e['code'] == 200) {
                    await sqlLite.open();
                    await sqlLite.delLoginInfo();
                    Navigator.pushNamedAndRemoveUntil(context, '/start', (route) => route == null);
                  }
                });
              },
              child: Icon(Icons.cancel),
            )
          ],
        ),
      ),
    );
  }
}
