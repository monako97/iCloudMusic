import 'package:flutter/cupertino.dart';
import '../searchContextScreen.dart';
class MySearchTextField extends StatefulWidget{
  final changCallBack;
  MySearchTextField({
    Key key,
    this.changCallBack
}): super(key:key);
  @override
  _MySearchTextField createState() => _MySearchTextField();
}
class _MySearchTextField extends State<MySearchTextField>{
  TextEditingController _searchContext;
  @override
  void initState() {
    _searchContext = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _searchContext.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _searchContext,
      decoration: BoxDecoration(
          color: Color.fromRGBO(150, 150, 150, 0.1),
          borderRadius: BorderRadius.circular(25.0)),
      padding: EdgeInsets.only(
          left: 10, top: 5, bottom: 5, right: 10),
      prefix: Container(
        margin: EdgeInsets.only(left: 10),
        child: Icon(
          CupertinoIcons.search,
          color: Color.fromRGBO(1, 1, 1, 0.3),
        ),
      ),
      textInputAction: TextInputAction.search,
      placeholder: "搜索",
      placeholderStyle: TextStyle(
        fontFamily: "SF-UI-Display-Medium",
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(1, 1, 1, 0.3),
      ),
      style: TextStyle(
        fontFamily: "SF-UI-Display-Medium",
      ),
      autofocus: false,
      onSubmitted: (v) {
        // 按下回车按钮调用搜索方法（这里使用的是router）
        Navigator.push(context,
            CupertinoPageRoute(builder: (BuildContext context) {
              return SearchScreen(searchString: v);
            }));
      },
      onChanged: (e) {
        widget.changCallBack(e);
      },
    );
  }
}