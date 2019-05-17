import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
class SingerHotScreen extends StatefulWidget {
  @override
  _SingerHotScreenState createState() => _SingerHotScreenState();
}

class _SingerHotScreenState extends State<SingerHotScreen> {
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: Text(""),
              middle: Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoTextField(
                        decoration: BoxDecoration(
                            color: C.DEFO,
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        padding: EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 10),
                        prefix: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(CupertinoIcons.search,
                            color: Color.fromRGBO(1, 1, 1, 0.3),),
                        ),
                        textInputAction: TextInputAction.search,
                        placeholder: "搜索",
                        placeholderStyle: TextStyle(
                          fontFamily: F.Medium,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(1, 1, 1, 0.3),
                        ),
                        style: TextStyle(
                          fontFamily: F.Medium,
                        ),
                        autofocus: true,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("取消",style: TextStyle(
                          color: C.DEF,
                          fontFamily: F.Medium
                      ),),
                      padding: EdgeInsets.fromLTRB(15,5,5,5),
                    )
                  ],
                ),
              ),
              padding: EdgeInsetsDirectional.only(end:0),
              trailing: CupertinoButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(CupertinoIcons.profile_circled,color: C.DEF,size: 26,),
                padding: EdgeInsets.all(5),
              ),
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
//              border: null
            ),
            child: Center(
                child: ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      title: Text("title$index"),
                      subtitle: Text("subtitle$index"),
                      onTap: (){
                        print(index);
                      },
                    );
                  },
                  itemCount: 30,
                )
            )
        ),
    );
  }
}
