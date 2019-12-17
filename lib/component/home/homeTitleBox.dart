import 'package:flutter/cupertino.dart';
class HomeTitleBox extends StatefulWidget{
  final String title;
  HomeTitleBox({Key key, this.title}) : super(key: key);
  @override
  _HomeTitleBox createState() => _HomeTitleBox();
}
class _HomeTitleBox extends State<HomeTitleBox>{
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
    return Container(
        margin: EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(widget.title,
                style: TextStyle(
                    fontFamily: "SF-UI-Display-Semibold",
                    fontSize: 30.0,
                    color: Color.fromRGBO(24, 29, 40, 0.87)
                ),
              ),
            ),
            CupertinoButton(
              onPressed: (){
                print(widget.title);
              },
              padding: EdgeInsets.only(right: 0,top: 15),
              child: Text("See all",
                style: TextStyle(
                    fontFamily: "SF-UI-Display-Medium",
                    fontSize: 15.0,
                    color: Color.fromRGBO(84, 102, 174, 1)
                ),
              ),
            )
          ],
        )
    );
  }
}