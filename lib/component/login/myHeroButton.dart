import 'package:flutter/material.dart';
class MyHeroButton extends StatefulWidget{
  final String tag;
  final String title;
  final double marginBottom;
  final callBack;
  MyHeroButton({
    Key key,
    @required this.tag,
    @required this.title,
    @required this.callBack,
    this.marginBottom
}) : super(key : key);
  @override
  _MyHeroButton createState() => _MyHeroButton();
}
class _MyHeroButton extends State<MyHeroButton>{
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Container(
        width: 325.0,
        height: 60,
        margin: EdgeInsets.only(top: 70.0,bottom: widget.marginBottom??20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(colors: <Color>[
              Color.fromRGBO(28, 224, 218, 1),
              Color.fromRGBO(71, 157, 228, 1)
            ]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(159, 210, 243, 0.35),
                  blurRadius: 24.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 12.0)
              )
            ]
        ),
        child: Builder(builder: (context) {
          return Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    try{
                      Form.of(context).validate() ? widget.callBack() : print("请填写完表单");
                    }catch(e){
                      widget.callBack();
                    }
                  },
                  splashColor: Color.fromRGBO(28, 224, 218, 0.5),
                  borderRadius:
                  BorderRadius.circular(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: "SF-UI-Display-Regular")),
                  )),
            ),
          );
        }),
      ),
    );
  }

}
class MyImgButton extends StatefulWidget{
  final double width;
  final String img;
  final String title;
  final callBack;
  MyImgButton({
    Key key,
    @required this.width,
    @required this.img,
    @required this.title,
    @required this.callBack
  }) : super(key : key);
  @override
  _MyImgButton createState() => _MyImgButton();
}
class _MyImgButton extends State<MyImgButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color.fromRGBO(159, 210, 243, 0.35),
                blurRadius: 24.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 12.0)
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              widget.callBack();
            },
            borderRadius:
            BorderRadius.circular(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 18.0, right: 10.0),
                    child: Image.asset(widget.img,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  Text(widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(24, 29, 40, 1),
                          fontSize: 18.0,
                          fontFamily: "SF-UI-Display-Regular"
                      ))
                ],
              ),
            )),
      ),
    );
  }
}