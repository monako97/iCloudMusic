import 'package:flutter/material.dart';
class NewRelease extends StatefulWidget{
  _NewRelease createState() => _NewRelease();
}
class _NewRelease extends State<NewRelease>{
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  // 推荐新歌data
  final List<Map<String,dynamic>> newReleaseTmpl = <Map<String,dynamic>>[{
    "img": "assets/images/cd1.png"
  },{
    "img": "assets/images/cd2.png"
  },{
    "img": "assets/images/cd3.png"
  },{
    "img": "assets/images/cd4.png"
  },{
    "img": "assets/images/cd5.png"
  }];
  final List<List<BoxShadow>> listBoxShadow = <List<BoxShadow>>[<BoxShadow>[BoxShadow(
    color: Color.fromRGBO(248, 53, 73, 0.15),
    blurRadius: 15.0,
    offset: Offset(0.0, 5.0),
  )],
    <BoxShadow>[BoxShadow(
      color: Color.fromRGBO(20, 26, 30, 0.15),
      blurRadius: 15.0,
      offset: Offset(0.0, 5.0),
    )],
    <BoxShadow>[BoxShadow(
      color: Color.fromRGBO(122, 43, 60, 0.15),
      blurRadius: 15.0,
      offset: Offset(0.0, 5.0),
    )],
    <BoxShadow>[BoxShadow(
      color: Color.fromRGBO(49, 208, 190, 0.15),
      blurRadius: 15.0,
      offset: Offset(0.0, 5.0),
    )],
    <BoxShadow>[BoxShadow(
      color: Color.fromRGBO(174, 135, 146, 0.15),
      blurRadius: 15.0,
      offset: Offset(0.0, 5.0),
    )]];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(20.0,0,20.0,0.0),
            alignment: Alignment.bottomLeft,
            child: Text("tracks, albums and compilations",
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "SF-UI-Display-Regular",
                  color: Color.fromRGBO(24, 29, 40, 0.64)
              ),
            )
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 20.0),
            child: newReleaseTemp(newReleaseTmpl)
        )
      ],
    );
  }
  // 新歌
  Widget newReleaseTemp(d){
    final List<Widget> _newReleaseList = List();
    for(int i = 0; i<d.length;i++){
      final Widget item = Container(
        margin: EdgeInsets.fromLTRB(20.0, 15.0, 0, 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64),
          boxShadow: listBoxShadow[i],
          border: Border.all(color: Colors.white,width: 2.0),
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage(d[i]['img']),
          backgroundColor: Colors.transparent,
          radius: 32,
          child: Container(
            width: 16.0,
            height: 16.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white,width: 2.0)
            ),
          ),
        ),
      );
      _newReleaseList.add(item);
    }
    return Row(
      children: _newReleaseList,
    );
  }
}


