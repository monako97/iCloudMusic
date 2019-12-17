import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/component/searchScreen.dart';
class SearchMiddleButton extends StatefulWidget{
  @override
  _SearchMiddleButton createState() => _SearchMiddleButton();
}
class _SearchMiddleButton extends State<SearchMiddleButton>{
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
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) {
              return HomeSScreen();
            }));
      },
      child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Color.fromRGBO(150, 150, 150, 0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Icon(CupertinoIcons.search,
                    size: 19.0, color: Color.fromRGBO(1, 1, 1, 0.3)),
              ),
              Text("搜索",
                  style: TextStyle(
                      fontFamily: "SF-UI-Display-Medium",
                      color: Color.fromRGBO(1, 1, 1, 0.3),
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0)),
            ],
          )),
    );
  }
}