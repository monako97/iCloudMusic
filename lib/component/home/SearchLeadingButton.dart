import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/component/userInfo.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
class SearchLeadingButton extends StatefulWidget{
  @override
  _SearchLeadingButton createState() => _SearchLeadingButton();
}
class _SearchLeadingButton extends State<SearchLeadingButton>{
  Future<Map<String, dynamic>> queryUserInIf()async{
    final sqlLite = SqlLite();
    await sqlLite.open();
    List<Map<String,dynamic>> _u = await sqlLite.queryUserInfo();
    return _u[0];
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: queryUserInIf(),
      builder: (BuildContext context,AsyncSnapshot snap){
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
              return UserInfoScreen();
            }));
          },
          child: Container(
            width: 35.0,
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 8.0),
            decoration: BoxDecoration(
                color: CupertinoColors.systemGreen,
                borderRadius: BorderRadius.circular(50.0),
                image: DecorationImage(
                  image: snap.hasData ? NetworkImage(snap.data['avatarUrl']) : AssetImage("assets/images/0.png"),
                  fit: BoxFit.cover,
                )),
          ),
        );
      },
    );
  }
}