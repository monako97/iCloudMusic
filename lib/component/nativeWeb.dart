import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.urls,
          javascriptMode: JavascriptMode.unrestricted
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context,(route) => route == null);
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.keyboard_arrow_left),
      ),
    );
  }
}
