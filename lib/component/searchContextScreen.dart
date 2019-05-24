import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/component/loading.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:icloudmusic/utils/commotRequest.dart';
class SearchScreen extends StatefulWidget {
  final String searchString;
  SearchScreen({Key key, @required this.searchString}):super(key:key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  TextEditingController _searchContext = TextEditingController();
  Map<String, dynamic> _searchSuggest; // 搜索建议
  @override
  void initState() {
    _searchContext.text = widget.searchString;
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
                  leading:  CupertinoButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.back,color: C.DEF,size: 26,),
                    padding: EdgeInsets.fromLTRB(10.0,5.0,5.0,5.0),
                  ),
                  middle: Container(
                    margin: EdgeInsets.only(right: 10),
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
                        )
                    ),
                  ),
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                  border: null,
                padding: EdgeInsetsDirectional.only(end: 0),
              ),
              child: FutureBuilder(
                future: H.searchSong(widget.searchString, context),
                builder: (BuildContext context,AsyncSnapshot snap){
                  if(!snap.hasData){
                    print(snap.data);
                    return Center(
                      child: loadingWidgetTwo(),
                    );
                  } else if(snap.data['code']!=200){
                    return Center(
                      child: Text("${snap.data['msg']}"),
                    );
                  } else if(snap.data['result']['songCount']<=0){
                    return Center(
                      child: Text("哈哈哈哈！没有这首歌哟～"),
                    );
                  } else{
                    return Center(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context,int index){
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 15,right: 15),
                            title: Text(snap.data['result']['songs'][index]['name'],
                                style: TextStyle(
                                  fontFamily: F.Bold,
                                  color: C.DEF,
                                ),
                                overflow: TextOverflow.ellipsis
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snap.data['result']['songs'][index]['artists'][0]['name']+' - '+snap.data['result']['songs'][index]['name'],
                                    style: TextStyle(
                                        fontFamily: F.Medium
                                    ),
                                    overflow: TextOverflow.ellipsis
                                ),
                                Text(
                                    snap.data['result']['songs'][index]['alias'].length>0?snap.data['result']['songs'][index]['alias'][0]:'',
                                    style: TextStyle(
                                        fontFamily: F.Medium
                                    ),
                                    overflow: TextOverflow.ellipsis
                                ),
                              ],
                            ),
                            onTap: (){
                              print(snap.data['result']['songs'][index]['name']);
                            },
                          );
                        },
                        itemCount: snap.data['result']['songs'].length,
                      ),
                    );
                  }
                },
              )
          ),
        ),
        resizeToAvoidBottomPadding: true,
    );
  }
}