import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
class HistoricalAccount extends StatefulWidget{
  final setPhone;
  final setCountry;
  final setPassWord;
  final setRemember;
  final doLogin;
  HistoricalAccount({
    Key key,
    @required this.setCountry,
    @required this.setPhone,
    @required this.setPassWord,
    @required this.setRemember,
    @required this.doLogin
  }) : super(key : key);
  @override
  _HistoricalAccount createState() => _HistoricalAccount();
}
class _HistoricalAccount extends State<HistoricalAccount>{
  final sqlLite = SqlLite();
  // 缓存的用户信息
  Future accountList() async {
    await sqlLite.open();
    return await sqlLite.queryForm('loginPhone');
  }
  Widget oldUserList(d){
    if(d==null||d.length==0){
      return Container(
        width: 325.0,
        height: 15.0
      );
    }
    final List<Widget> _userList = List();
    for (int i = d.length - 1; i >= 0; i--) {
      final Widget item = Container(
          width: 175,
          height: 35,
          margin: EdgeInsets.only(bottom: 10.0),
          child: Material(
            color: Colors.deepPurple.shade200,
            borderRadius: BorderRadius.circular(17.5),
            child: InkWell(
              onTap: (){
                widget.setPhone(d[i]['phone']);
                widget.setCountry(d[i]['countrycode']);
                widget.setPassWord(d[i]['password']);
                widget.setRemember(false);
                widget.doLogin();
              },
              borderRadius: BorderRadius.circular(17.5,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: d[i]['avatarUrl']==null ?
                    AssetImage("assets/images/0.png") :
                    NetworkImage(d[i]['avatarUrl']),
                    backgroundColor: Colors.green.shade200,
                    radius: 17.5,
                  ),
                  Text(" "+d[i]['phone'].toString(),style: TextStyle(
                      color: Colors.white,
                      fontFamily: "SF-UI-Display-Regular",
                      fontSize: 14.0
                  )),
                  IconButton(
                    onPressed: ()async{
                      await sqlLite.db.delete('loginPhone',where: 'phone=${d[i]['phone']}');
                      setState(() {});
                    },
                    iconSize: 17.5,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Colors.white70,
                    icon: Icon(Icons.cancel),
                  )
                ],
              ),
            ),
          )
      );
      _userList.add(item);
    }
    return GroovinExpansionTile(
      inkwellRadius: BorderRadius.circular(35),
      boxDecoration: BoxDecoration(
        color: Colors.white70
      ),
      title: Text("There's ${d.length} historical account",
          style: TextStyle(
              color: Color.fromRGBO(24, 29, 40, 0.64),
              fontSize: 14.0,
              fontFamily: "SF-UI-Display-Medium")),
      children: <Widget>[SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _userList)
      )],
    );
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: accountList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){

          return Container(
              width: 325.0,
              child: oldUserList(snapshot.data)
          );
        }else{
          return Container(
            width: 325.0,
            height: 15.0,
          );
        }
      }
    );
  }
}