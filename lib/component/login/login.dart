import 'package:flutter/material.dart';
import 'package:icloudmusic/component/registration/registration.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/component/login/userInput.dart';
import 'package:icloudmusic/component/login/historicalAccount.dart';
import 'package:icloudmusic/component/login/passWordInput.dart';
import 'package:icloudmusic/component/login/rememberMe.dart';
import 'package:icloudmusic/component/login/myHeroButton.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
import 'package:icloudmusic/widget/loading.dart'; // loading
import 'package:icloudmusic/const/deviceInfo.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final sqlLite = SqlLite();
  Map<String, dynamic> formDE;
  bool _rememberMe; //记住用户
  bool _autoForm; // 自动检查表单
  doLogin() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await HttpUtils.request('/login/cellphone',data: formDE,load: true);
    print(result);
    if (result != null && result['code'] == 200) {
      await sqlLite.open();
      // 登录成功，保存数据 登录的账号信息记录一下
      await sqlLite.insertLoginInfo(result['profile'], formDE, _rememberMe);
      // 登录成功跳转页面 并且关闭给定路由的之前的所有页面
      List<Map<String,dynamic>> info = await sqlLite.queryLogin();
      if(info[0]['code'] == 200){
        if (info[0]['first'] == 1) {
          //首次使用该账号登录
          Navigator.pushNamedAndRemoveUntil(
              context, '/startWelcome', (route) => route == null);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/main', (route) => route == null);
        }
      }
    }
  }
  void setPhone(phone){
    formDE["phone"] = phone;
  }
  void setCountry(country){
    formDE["countrycode"] = country;
  }
  void setPassWord(password){
    formDE["password"] = password;
  }
  void setRemember(bool bool){
    _rememberMe = bool;
  }

  @override
  void initState() {
    super.initState();
    formDE = {
      'phone': null,
      'password': null,
      'countrycode': "86"
    };
    _rememberMe = false; //记住用户
    _autoForm = false; // 自动检查表单
  }
  @override
  void dispose() {
    super.dispose();
    print("销毁登录页");
  }

  Widget build(BuildContext context) {
    Loading.context = context; // 注入context
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "LOGIN",
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: "SF-UI-Display-Medium",
                color: Color.fromRGBO(24, 29, 40, 1)),
          ),
          centerTitle: true,
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Color.fromRGBO(24, 29, 40, 1)),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      FadeRoute(Registration())
                  );
                },
                icon: Icon(Icons.bubble_chart),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                // 触摸收起键盘
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 50.0),
                    child: Form(
                      onChanged: (){
                        if(!_autoForm){
                          setState(()=>_autoForm = true);
                        }
                      },
                      autovalidate: _autoForm,
                      child: Column(
                        children: <Widget>[
                          //账号
                          LoginUserInput(
                            setCountry: setCountry,
                            setPhone: setPhone,
                          ),
                          // 历史账号
                          HistoricalAccount(
                            setCountry: setCountry,
                            setPhone: setPhone,
                            setPassWord: setPassWord,
                            setRemember: setRemember,
                            doLogin: doLogin
                          ),
                          // 密码
                          PassWordInput(
                            setPassWord: setPassWord,
                          ),
                          // 忘记密码
                          Container(
                            width: 325.0,
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              padding: EdgeInsets.all(8.0),
                              onPressed: () => print("忘记密码"),
                              textTheme: ButtonTextTheme.primary,
                              child: Text(
                                "Forgotten password ?",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 29, 40, 0.64),
                                    fontSize: 14.0,
                                    fontFamily: "SF-UI-Display-Medium"),
                              ),
                            ),
                          ),
                          // 开启记住用户
                          RememberMe(
                            setRemember: setRemember,
                          ),
                          //登录
                          MyHeroButton(
                            title: "LOGIN",
                            tag: "LOGIN",
                            callBack: doLogin,
                            marginBottom: 0.0
                          ),
                          Container(
                            width: 304.0,
                            margin: EdgeInsets.only(top: 30.0),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Divider(
                                  height: 51.0,
                                  indent: 5.0,
                                  color: Color.fromRGBO(84, 102, 174, 0.15),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 66.0,
                                  color: Colors.white,
                                  child: Text(
                                    "OR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "SF-UI-Display-Regular",
                                        fontSize: 18.0,
                                        color:
                                        Color.fromRGBO(24, 29, 40, 0.54)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 第三方登录
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                MyImgButton(
                                    width: (DeviceInfo.width-385)>0 ? 155.0 : (DeviceInfo.width-70)/2,
                                  img: "assets/images/google.png",
                                  title: "Google",
                                  callBack: (){
                                    print("GOOGLE");
                                  }
                                ),
                                MyImgButton(
                                    width: (DeviceInfo.width-385)>0 ? 155.0 : (DeviceInfo.width-70)/2,
                                    img: "assets/images/facebook.png",
                                    title: "Facebook",
                                    callBack: (){
                                      print("Facebook");
                                    }
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  ))
            ],
          ),
        ),
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
    );
  }
}
