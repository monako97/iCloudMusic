import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:webview_flutter/webview_flutter.dart';
class NativeWebView extends StatefulWidget {
  // 接受路由传递的url
  final String urls;
  NativeWebView({Key key,@required this.urls}) : super(key: key);
  @override
  _NativeWebViewState createState() => _NativeWebViewState();
}
class _NativeWebViewState extends State<NativeWebView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.urls),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
        border: null,
      ),
      child: Builder(builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 45+DeviceInfo.padding),
          child: WebView(
              initialUrl: widget.urls,
              javascriptMode: JavascriptMode.unrestricted
          ),
        );
      }),
    );
  }
}
