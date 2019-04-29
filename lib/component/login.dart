import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flushbar/flushbar.dart'; //Toast插件
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
import 'package:icloudmusic/component/loading.dart';
import 'package:dio/dio.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  Dio dio = Dio();
  final SqlLites = new SqlLite();
  TextEditingController _nameController = new TextEditingController(); //用户名控制器
  TextEditingController _pswController = new TextEditingController(); //密码控制器
  bool passWordVisible = false; //密码是否可见
  bool RememberMe = false; //记住用户
  bool UserList = false; //是否打开用户select
  bool load = false; //加载状态
  var iscounty;

  doLogin() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => load = true);
    Map<String, dynamic> result = await HttpUtils.request(
        '/login/cellphone', data: formDE, method: HttpUtils.GET);
    if (result != null && result['code'] == 200) {
      setState(() => load = false);
      // 登录成功，保存数据
      await SqlLites.open();
      var xsa = await SqlLites.queryUserInfo();
      if (xsa.length > 0) {
        print("已有数据：${xsa.length}");
        if (xsa[0]['userId'] == result['profile']['userId']) {
          await SqlLites.insertLoginInfo(
              true, result['profile'], formDE, RememberMe);
        }
      } else {
        await SqlLites.insertLoginInfo(
            false, result['profile'], formDE, RememberMe);
      }
      // 登录成功跳转页面 并且关闭给定路由的之前的所有页面
      var fi = await SqlLites.queryLogin();
      if (fi[0]['first'] == 1) { //首次使用该账号登录
        await SqlLites.db.update("loginState", {"first": 0});
        Navigator.pushNamedAndRemoveUntil(
            context, '/startWelcome', (route) => route == null);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/drawer', (route) => route == null);
      }
    } else {
      setState(() => load = false);
      new Flushbar(
        messageText: Text(
          result['msg'] != null ? result['msg'] : "登录失败",
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        //显示位置
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.white,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 10,
        duration: Duration(seconds: 4),
        //显示时长
        leftBarIndicatorColor: Colors.red[400],
        backgroundColor: Colors.red[400],
      )
        ..show(context);
    }
  }

  // 创建一个Popup组件
  void _openCupertinoCountryPicker() =>
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return CountryPickerCupertino(
              pickerItemHeight: 50.0,
              pickerSheetHeight: 300.0,
              onValuePicked: (country) =>
                  setState(() {
                    iscounty = CountryPickerUtils.getDefaultFlagImage(country);
                    formDE['countrycode'] = country.phoneCode;
                  }),
            );
          });

  @override
  void dispose() {
    dio.resolve("停止http请求");
    _nameController.dispose();
    _pswController.dispose();
    print('页面销毁时，销毁控制器');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          iconTheme: IconThemeData(
            color: Color.fromRGBO(24, 29, 40, 1),
          ),
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
                      // 开启自动校验
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          //账号
                          Container(
                              width: 325.0,
                              child: InkWell(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 20.0,
                                      fontFamily: "SF-UI-Display-Regular"),
                                  controller: _nameController,
                                  keyboardType: TextInputType.phone,
                                  // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11)],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
//                                  fillColor: Color.fromRGBO(246, 247, 251, 0.8),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      // 选中时的样式
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        borderSide: BorderSide.none
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      // 选中时的样式
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        borderSide: BorderSide.none
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      // 选中时的样式
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        borderSide: BorderSide.none
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        borderSide: BorderSide.none
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        return setState(() {
                                          print("展开用户表");
                                          this.UserList = !this.UserList;
                                        });
                                      },
                                      icon: Icon(UserList
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down),
                                    ),
                                    prefixIcon: IconButton(
                                        onPressed: _openCupertinoCountryPicker,
                                        padding: EdgeInsets.all(0.0),
                                        icon: iscounty == null
                                            ? getFlagImage()
                                            : iscounty
                                    ),
                                    labelText: "Phone",
//                                  contentPadding:
//                                  EdgeInsets.only(left: 20.0,right: 0.0,top: 0.0,bottom: 30.0),
                                    contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
                                    hintText: "Enter You Phone Number",
                                    suffix: IconButton(
                                        onPressed: () => setState(() =>
                                            _nameController.clear()),
                                        icon: Icon(Icons.highlight_off)),
                                  ),
                                  validator: (String value) {
                                    formDE['phone'] = value;
                                    return value
                                        .trim()
                                        .length > 0 ? null : '请输入账号';
                                  },
                                ),
                              )
                          ),
                          //密码
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: InkWell(
                              child: TextFormField(
                                style: TextStyle(fontSize: 20.0,
                                    fontFamily: "SF-UI-Display-Regular"),
                                obscureText: !this.passWordVisible,
                                controller: _pswController,
                                cursorColor: Colors.pinkAccent,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "PassWord",
//                                fillColor: Color.fromRGBO(246, 247, 251, 0.8),
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.only(left: 20.0,
                                      right: 0.0,
                                      top: 20.0,
                                      bottom: 20.0),
                                  focusedBorder: OutlineInputBorder(
                                    // 选中时的样式
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      borderSide: BorderSide.none
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    // 选中时的样式
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      borderSide: BorderSide.none
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // 选中时的样式
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      borderSide: BorderSide.none
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      borderSide: BorderSide.none
                                  ),
                                  hintText: "Enter You PassWord",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        this.passWordVisible =
                                        !this.passWordVisible;
                                      });
                                    },
//                                alignment: Alignment.bottomCenter,
                                    icon: Icon(passWordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                validator: (String value) {
                                  formDE['password'] = value;
                                  return value
                                      .trim()
                                      .length > 5 ? null : '密码不能少于6位';
                                },
                              ),
                            ),
                          ),
                          // 忘记密码
                          Container(
                            width: 325.0,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10.0),
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
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5.0),
                                  height: 28.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: RememberMe
                                          ? null
                                          : Color.fromRGBO(246, 247, 251, 1),
                                      gradient: RememberMe
                                          ? LinearGradient(colors: [
                                        Color.fromRGBO(28, 224, 218, 1),
                                        Color.fromRGBO(71, 157, 228, 1)
                                      ])
                                          : null),
                                  child: CupertinoSwitch(
                                    onChanged: (e) {
                                      setState(() => RememberMe = e);
                                    },
                                    activeColor: Colors.transparent,
                                    value: RememberMe,
                                  ),
                                ),
                                Text(
                                  "  Remember me?",
                                  style: TextStyle(
                                      color: Color.fromRGBO(24, 29, 40, 1),
                                      fontSize: 16.0,
                                      fontFamily: "SF-UI-Display-Medium"),
                                )
                              ],
                            ),
                          ),
                          //登录
                          Container(
                            width: 325.0,
                            height: 60,
                            margin: EdgeInsets.only(top: 70.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(28, 224, 218, 1),
                                  Color.fromRGBO(71, 157, 228, 1)
                                ]),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: const Color.fromRGBO(
                                        159, 210, 243, 0.35),
                                    blurRadius: 24.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, 12.0),
                                  ),
                                ]),
                            child: Builder(builder: (context) {
                              return Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () =>
                                      Form.of(context).validate()
                                          ? doLogin()
                                          : null,
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text("LOGIN",
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
                          // OR
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
                                        color: Color.fromRGBO(
                                            24, 29, 40, 0.54)),
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
                                Container(
                                  width: 155.0,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color:
                                          const Color.fromRGBO(
                                              159, 210, 243, 0.35),
                                          blurRadius: 24.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0, 12.0),
                                        ),
                                      ]),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          print("Google");
                                        },
                                        borderRadius: BorderRadius.circular(
                                            8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 18.0, right: 10.0),
                                                child: Image.asset(
                                                  "assets/images/google.png",
                                                  width: 24.0,
                                                  height: 24.0,
                                                ),
                                              ),
                                              Text("Google",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                      Color.fromRGBO(
                                                          24, 29, 40, 1),
                                                      fontSize: 18.0,
                                                      fontFamily:
                                                      "SF-UI-Display-Regular"))
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                Container(
                                  width: 155.0,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color:
                                          const Color.fromRGBO(
                                              159, 210, 243, 0.35),
                                          blurRadius: 24.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0, 12.0),
                                        ),
                                      ]),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          print("Facebook");
                                        },
                                        borderRadius: BorderRadius.circular(
                                            8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 18.0, right: 10.0),
                                                child: Image.asset(
                                                  "assets/images/facebook.png",
                                                  width: 24.0,
                                                  height: 24.0,
                                                ),
                                              ),
                                              Text("Facebook",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                      Color.fromRGBO(
                                                          24, 29, 40, 1),
                                                      fontSize: 18.0,
                                                      fontFamily:
                                                      "SF-UI-Display-Regular"))
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              load ? Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: LoadingWidget(),
              ) : Container(),
            ],
          ),
        )
    );
  }
}
// 默认的国旗
Widget getFlagImage() =>
    Image.asset(
      "assets/images/cn.png",
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
    );
Map<String, dynamic> formDE = {
  'phone': null,
  'password': null,
  'countrycode': "86"
};