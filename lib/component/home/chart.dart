import 'package:flutter/material.dart';
class ChartHome extends StatefulWidget{
  @override
  _ChartHome createState() => _ChartHome();
}
class _ChartHome extends State<ChartHome>{
  // 0：排名不变，1：上升，2：下降
  final List<Map<String,dynamic>> chartTmpl = <Map<String,dynamic>>[{
    "img": "assets/images/cd6.png",
    "state": 0,
    "name": "Nice For What",
    "user": "Drake"
  }, {
    "img": "assets/images/cd7.png",
    "state": 1,
    "name": "Psycho",
    "user": "Post Malone Feat. Ty Dolla Ign"
  },{
    "img": "assets/images/cd8.png",
    "state": 2,
    "name": "Never Be The Same",
    "user": "Camila Cabello"
  },{
    "img": "assets/images/cd9.png",
    "state": 0,
    "name": "Mine",
    "user": "Bazzi"
  },{
    "img": "assets/images/cd10.png",
    "state": 0,
    "name": "Powerglide",
    "user": "Rae Sremmurd Feat. Juicy J"
  }];
  final List<List<BoxShadow>> listBoxShadow = <List<BoxShadow>>[
    <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(248, 53, 73, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )
    ],
    <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(20, 26, 30, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )
    ],
    <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(122, 43, 60, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )
    ],
    <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(49, 208, 190, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )
    ],
    <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(174, 135, 146, 0.15),
        blurRadius: 15.0,
        offset: Offset(0.0, 5.0),
      )
    ]
  ];
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
    final List<Widget> _charts = List();
    for(int i = 0;i < chartTmpl.length;i++){
      final Widget _item = Container(
        margin: EdgeInsets.only(left: 15.0,right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${i+1}",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 29, 40, 0.36),
                      fontSize: 18.0,
                      fontFamily: "SF-UI-Display-Medium"
                  ),
                ),
                _icon(chartTmpl[i]['state'])
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 18, 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
                boxShadow: listBoxShadow[i],
                border: Border.all(color: Colors.white,width: 2.0),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(chartTmpl[i]['img']),
                backgroundColor: Colors.transparent,
                radius: 31,
                child: Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: Colors.white,width: 2.0)
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${chartTmpl[i]['name']}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(24, 29, 40, 1),
                          fontSize: 16.0,
                          fontFamily: "SF-UI-Display-Semibold"
                      )
                  ),
                  Text("${chartTmpl[i]['user']}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: "SF-UI-Display-Regular",
                        color: Color.fromRGBO(112, 112, 112, 1)
                    ),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: (){
                print("more_vert");
              },
              padding: EdgeInsets.only(right: 0,left: 20),
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(24, 29, 40, 0.54),
              ),
            )
          ],
        ),
      );
      _charts.add(_item);
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: _charts,
      ),
    );
  }
  Widget _icon(s){
    Widget _ics;
    switch(s){
      case 0:
        _ics = Icon(Icons.remove,
          color: Colors.grey,
        );
        break;
      case 1:
        _ics = Icon(Icons.arrow_drop_up,
          color: Colors.green,
        );
        break;
      case 2:
        _ics = Icon(Icons.arrow_drop_down,
          color: Colors.red,
        );
        break;
      default:
        break;
    }
    return _ics;
  }
}


