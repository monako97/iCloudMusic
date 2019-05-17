import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:icloudmusic/const/resource.dart';
class NativeWebCupertino extends StatefulWidget {
  // 接受路由传递的url
  final String urls;
  NativeWebCupertino({Key key,@required this.urls}) : super(key: key);
  @override
  _NativeWebCupertinoState createState() => _NativeWebCupertinoState();
}
class _NativeWebCupertinoState extends State<NativeWebCupertino> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.urls),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: Builder(builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 45+D.topPadding),
          child: WebView(
              initialUrl: widget.urls,
              javascriptMode: JavascriptMode.unrestricted
          ),
        );
      }),
    );
  }
}
