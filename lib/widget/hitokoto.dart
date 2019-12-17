import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
class HitOKOto extends StatefulWidget{
  @override
  _HitOKOto createState() => _HitOKOto();
}
class _HitOKOto extends State<HitOKOto>{
  final sqlLite = SqlLite();
  Future getHitOKOto() async {
    List<Map<dynamic, dynamic>> _hitLists;
    var response = await HttpUtils.request('https://v1.hitokoto.cn');
    await sqlLite.open();
    if(response!=null){
      // 将获取到的一言存入数据
      await sqlLite.insertHit(response);
    }
    // 从数据库取出数据
    _hitLists = await sqlLite.queryForm('hitokoto');
    response = _hitLists[_hitLists.length-1];
    return response;
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
      future: getHitOKOto(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        return Card(
          margin: EdgeInsets.fromLTRB(20.0,10.0,20.0,35.0),
          color: Color.fromRGBO(204, 171, 218, 1),
          child: InkWell(
            onTap: ()=>setState((){}),
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(snapshot.hasData?snapshot.data['hitokoto']:"HITOKOTO",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: "SF-UI-Display-Regular"
                          )
                      )
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(snapshot.hasData?'${snapshot.data['froms']}':"MONAKO",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontFamily: "SF-UI-Display-Medium"
                          )
                      )
                    )
                  ]
                )
            ),
          ),
        );
      },
    );
  }
}