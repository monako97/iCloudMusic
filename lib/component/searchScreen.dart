import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/component/searchContextScreen.dart';
import 'package:icloudmusic/component/loading.dart';
import 'package:icloudmusic/const/resource.dart';
class HomeSScreen extends StatefulWidget {
  @override
  _HomeSScreenState createState() => _HomeSScreenState();
}

class _HomeSScreenState extends State<HomeSScreen>{
  bool _isLoad = true;
  TextEditingController _searchContext = TextEditingController();
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
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: Text(""),
              middle: Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoTextField(
                        controller: _searchContext,
                        decoration: BoxDecoration(
                            color: C.OPACITY_DEF,
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
                        autofocus: false,
                        onSubmitted: (v){
                          // 按下回车按钮调用搜索方法（这里使用的是router）
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (BuildContext context){
                                return SearchScreen(searchString: v);
                              }
                          ));
                        },
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
              border: null
            ),
            child: Center(
                child: _isLoad ? ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 0,right: 0),
                      leading: Container(
                        width: 40.0,
                        alignment: Alignment.center,
                        child: Text(
                          "${index+1}",
                          style: TextStyle(
                              fontFamily: F.Regular,
                              color: index<3? Colors.red : Colors.grey,
                              fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(recentSuggest[index]['title'],style: TextStyle(
                              fontFamily: F.Bold,
                              color: C.DEF
                          ),),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(recentSuggest[index]['hotnum'].toString(),style: TextStyle(
                                fontFamily: F.Medium,
                                color: index<3? Colors.red : Colors.grey,
                                fontWeight: FontWeight.w300,
                                fontSize: 13
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              recentSuggest[index]['hot']?"HOT":"",
                              style: TextStyle(
                                  fontFamily: F.Medium,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),),
                          )
                        ],
                      ),
                      subtitle: Text(recentSuggest[index]['subtitle'],
                        style: TextStyle(
                          fontFamily: F.Medium
                      ),),
                      onTap: (){
                        setState(() {
                          _searchContext.text = recentSuggest[index]['title'];
                        });
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (BuildContext context){
                            return SearchScreen(searchString: _searchContext.text);
                          }
                        ));
                      },
                    );
                  },
                  itemCount: recentSuggest.length,
                ) : loadingWidgetTwo(),
            )
        ),
      )
    );
  }
}
// 热搜数据
List<Map<String,dynamic>> recentSuggest = [{
    "title": "只因你太美",
    "hotnum": 4012771,
    "subtitle": "一起见证全新实力男团时代的开启",
    "hot": true
  },
  {
    "title": "雨夜冷",
    "hotnum": 4012770,
    "subtitle": "听完Beyond这首歌，心也被寂寞包裹",
    "hot": true
  },
  {
    "title": "心如止水",
    "hotnum": 3114600,
    "subtitle": "水声和男声温柔得心都要化了！",
    "hot": true
  },
  {
    "title": "孤单心事",
    "hotnum": 2992283,
    "subtitle": "颜人中的全新演绎带你一起走出心事～",
    "hot": false
  },
  {
    "title": "归去来兮",
    "hotnum": 2089200,
    "subtitle": "花粥的最新专辑上线了，快来听歌吧！",
    "hot": false
  },
  {
    "title": "人间不值得",
    "hotnum": 1540400,
    "subtitle": "人间不值得，但音乐值得",
    "hot": false
  },
  {
    "title": "慢慢喜欢你",
    "hotnum": 1458200,
    "subtitle": "莫文蔚新歌给你细水长流的甜蜜浪漫",
    "hot": true
  },
  {
    "title": "撕夜",
    "hotnum": 1457700,
    "subtitle": "小时候还以为是情歌，现在才听出其中的现实",
    "hot": false
  },
  {
    "title": "我曾",
    "hotnum": 1243900,
    "subtitle": "总不能还没努力就向生活妥协吧",
    "hot": false
  },
  {
    "title": "孤身",
    "hotnum": 1243300,
    "subtitle": "原创音乐徐斌龙最新单曲",
    "hot": false
  },
  {
    "title": "大碗宽面",
    "hotnum": 931900,
    "subtitle": "吴亦凡最新单曲上线！快来支持！",
    "hot": false
  },
  {
    "title": "lemon",
    "hotnum": 741790,
    "subtitle": "米津玄师献唱日剧《非自然死亡》主题曲",
    "hot": true
  }];