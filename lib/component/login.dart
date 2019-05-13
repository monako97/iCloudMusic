import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:icloudmusic/component/registration.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:flushbar/flushbar.dart'; //Toast插件
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:icloudmusic/Utils/sqlite.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
import 'package:xlive_switch/xlive_switch.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:icloudmusic/component/loading.dart';
import 'package:dio/dio.dart';
import 'dart:ui';

// 屏幕宽度
double SHeight = MediaQueryData
    .fromWindow(window)
    .size
    .height;
double SWidth = MediaQueryData
    .fromWindow(window)
    .size
    .width;
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Dio dio = Dio();
  List _oldUser;
  final SqlLites = new SqlLite();
  TextEditingController _nameController; //用户名控制器
  TextEditingController _pswController; //密码控制器
  bool passWordVisible = false; //密码是否可见
  bool RememberMe = false; //记住用户
  bool load = false; //加载状态
  bool _listY = false; //开启列表
  var iscounty;

  Widget initOldUser(_oldUser) {
    List<Widget> _userList = new List();
    for (int i = _oldUser.length - 1; i >= 0; i--) {
      Widget item = IconButton(
        onPressed: () {
          formDE['phone'] = _oldUser[i]['phone'];
          formDE['password'] = _oldUser[i]['password'];
          formDE['countrycode'] = _oldUser[i]['countrycode'];
          RememberMe = false;
          doLogin();
        },
        icon: CircleAvatar(
          backgroundImage: NetworkImage(_oldUser[i]['avatarUrl']),
          backgroundColor: Colors.grey,
        ),
      );
      _userList.add(item);
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: _userList);
  }

  doLogin() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => load = true);
    Map<String, dynamic> result = await HttpUtils.request('/login/cellphone',
        data: formDE, method: HttpUtils.GET);
    if (result != null && result['code'] == 200) {
      setState(() => load = false);
      // 登录成功，保存数据
      await SqlLites.open();
      var xsa = await SqlLites.queryUserInfo();
      // 把登录的账号信息记录一下
      if (xsa.length > 0) {
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
      if (fi[0]['first'] == 1) {
        //首次使用该账号登录
        Navigator.pushNamedAndRemoveUntil(
            context, '/startWelcome', (route) => route == null);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/drawer', (route) => route == null);
      }
    } else {
      setState(() => load = false);
      FToash(result['msg'], "登录失败", false, context);
    }
  }

  @override
  void initState() {
    (() async {
      await SqlLites.open();
      //获取登录过的账号
      _oldUser = await SqlLites.queryForm('loginPhone');
      if (_oldUser.length > 0) {
        _listY = true;
      }
      setState(() {});
    })();
    _nameController = TextEditingController();
    _pswController = TextEditingController();
    super.initState();
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
                fontFamily: F.Medium,
                color: C.DEF),
          ),
          centerTitle: true,
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: C.DEF),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, FadeRoute((Registration())));
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
                    padding: EdgeInsets.fromLTRB(18.0, 50.0, 18.0, 50.0),
                    child: Form(
                      // 开启自动校验
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          //账号
                          GroovinExpansionTile(
                            initiallyExpanded: _listY,
                            inkwellRadius: BorderRadius.circular(8),
                            title: Container(
                              width: 325.0,
                              padding: SWidth <= 370 ? null : EdgeInsets.only(
                                  left: 21),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: F.Regular),
                                controller: _nameController,
                                keyboardType: TextInputType.phone,
                                // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11)
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  focusedBorder: C.InputBorderNone,
                                  focusedErrorBorder: C.InputBorderNone,
                                  enabledBorder: C.InputBorderNone,
                                  errorBorder: C.InputBorderNone,
                                  helperText: (_oldUser == null)
                                      ? null
                                      : (_oldUser.length > 0
                                      ? "有${_oldUser.length}个历史账户"
                                      : null),
                                  prefixIcon: IconButton(
                                      onPressed: _openCupertinoCountryPicker,
                                      padding: EdgeInsets.all(0.0),
                                      icon: iscounty == null
                                          ? FlagImage()
                                          : iscounty),
                                  labelText: "Phone",
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
                                  hintText: "Enter You Phone Number",
                                  suffix: IconButton(
                                      onPressed: () =>
                                          setState(
                                                  () =>
                                                  _nameController.clear()),
                                      icon: Icon(Icons.highlight_off)),
                                ),
                                validator: (String value) {
                                  formDE['phone'] = value;
                                  return value
                                      .trim()
                                      .length > 0
                                      ? null
                                      : '请输入账号';
                                },
                              ),
                            ),
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: _oldUser == null
                                      ? Container()
                                      : initOldUser(_oldUser),
                                ),
                              ),
                            ],
                          ),

                          //  密码
                          Container(
                            width: 335.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: F.Regular),
                              obscureText: !this.passWordVisible,
                              controller: _pswController,
                              cursorColor: Colors.pinkAccent,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "PassWord",
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 0.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                focusedBorder: C.InputBorderNone,
                                focusedErrorBorder: C.InputBorderNone,
                                enabledBorder: C.InputBorderNone,
                                errorBorder: C.InputBorderNone,
                                hintText: "Enter You PassWord",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      this.passWordVisible =
                                      !this.passWordVisible;
                                    });
                                  },
                                  icon: Icon(passWordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: (String value) {
                                formDE['password'] = value;
                                return value
                                    .trim()
                                    .length > 5
                                    ? null
                                    : '密码不能少于6位';
                              },
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
                                    fontFamily: F.Medium),
                              ),
                            ),
                          ),
                          // 开启记住用户
                          Container(
                            width: 325.0,
                            child: Row(
                              children: <Widget>[
                                Hero(
                                  tag: 'SWITCH',
                                  child: XlivSwitch(
                                    value: RememberMe,
                                    onChanged: (e) {
                                      setState(() => RememberMe = e);
                                    },
                                  ),
                                ),
                                Text(
                                  "  Remember me?",
                                  style: TextStyle(
                                      color: C.DEF,
                                      fontSize: 16.0,
                                      fontFamily: F.Medium),
                                )
                              ],
                            ),
                          ),
                          //登录
                          Hero(
                            tag: 'LOGIN',
                            child: Container(
                              width: 325.0,
                              height: 60,
                              margin: EdgeInsets.only(top: 70.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(colors: C.BTN_DEF),
                                  boxShadow: C.BTN_SHADOW),
                              child: Builder(builder: (context) {
                                return Container(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () =>
                                        Form.of(context).validate()
                                            ? doLogin()
                                            : null,
                                        splashColor:
                                        Color.fromRGBO(28, 224, 218, 0.5),
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text("LOGIN",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: F.Regular)),
                                        )),
                                  ),
                                );
                              }),
                            ),
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
                                        fontFamily: F.Regular,
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
                                Container(
                                  width: 155.0,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      boxShadow: C.BTN_SHADOW),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          print("Google");
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
                                                child: Image.asset(M.GG,
                                                  width: 24.0,
                                                  height: 24.0,
                                                ),
                                              ),
                                              Text("Google",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: C.DEF,
                                                      fontSize: 18.0,
                                                      fontFamily: F.Regular))
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
                                      boxShadow: C.BTN_SHADOW),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          print("Facebook");
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
                                                child: Image.asset(M.FB,
                                                  width: 24.0,
                                                  height: 24.0,
                                                ),
                                              ),
                                              Text("Facebook",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: C.DEF,
                                                      fontSize: 18.0,
                                                      fontFamily: F.Regular))
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
                  )),
              load
                  ? Container(
                height: SHeight,
                child: LoadingWidget(),
              )
                  : Container(),
            ],
          ),
        ));
  }
}

Map<String, dynamic> formDE = {
  'phone': null,
  'password': null,
  'countrycode': "86"
};
