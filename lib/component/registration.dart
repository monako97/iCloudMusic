import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart'; //Toast插件
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
import 'package:icloudmusic/component/login.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/component/loading.dart';
import 'package:dio/dio.dart';
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}
class _RegistrationState extends State<Registration> {
  Dio dio = Dio();
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _verifyController;
  TextEditingController _pswController;
  bool passWordVisible = false; //密码是否可见
  bool load = false; //加载状态
  bool getc = false;
  bool isV = false;
  String _txts = '获取验证码';
  String _ctcode = '86';
  var iscounty;

  getCtcode() async {
    if (formDE['phone']
        .trim()
        .length > 6) {
      setState(() => getc = true);
      // 收起键盘
      FocusScope.of(context).requestFocus(FocusNode());
      Map<String, dynamic> result = await HttpUtils.request(
          '/captch/sent', data: {'phone': formDE['phone'], 'ctcode': _ctcode},
          method: HttpUtils.GET);
      if (result != null && result['code'] == 200) {
        _txts = '已发送';
        isV = true;
        setState(() => getc = false);
      } else {
        _txts = '重新获取';
        setState(() => getc = false);
        Flushbar(
          messageText: Text(
            result['message'] != null ? result['message'] : "获取验证码失败",
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
  }

  doRegis() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    if (isV) {
      setState(() => load = true);
      // 验证验证码
      Map<String, dynamic> as = await HttpUtils.request(
          '/captch/verify', data: {
        'phone': formDE['phone'],
        'ctcode': _ctcode,
        'captcha': formDE['captcha']
      }, method: HttpUtils.GET);
      print(as);
      if (as != null && as['code'] == 200) {
        //验证成功后开始注册
        Map<String, dynamic> result = await HttpUtils.request(
            '/captch/register', data: formDE, method: HttpUtils.GET);
        if (result != null && result['code'] == 200) {
          setState(() => load = false);
          Flushbar(
            messageText: Text(
              result['message'] != null ? result['message'] : "注册成功",
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
            leftBarIndicatorColor: Colors.green[400],
            backgroundColor: Colors.green[400],
          )
            ..show(context);
        } else {
          setState(() => load = false);
          Flushbar(
            messageText: Text(
              result['message'] != null ? result['message'] : "注册失败",
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
      } else {
        setState(() => load = false);
        Flushbar(
          messageText: Text(
            as['message'] != null ? as['message'] : "验证码错误",
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
    } else {
      Flushbar(
        messageText: Text("请先获取验证码",
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

  @override
  void initState() {
    _nameController = TextEditingController();
    _pswController = TextEditingController();
    _phoneController = TextEditingController();
    _verifyController = TextEditingController();
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
                    _ctcode = country.phoneCode;
                  }),
            );
          });

  @override
  void dispose() {
    dio.resolve("停止http请求");
    _nameController.dispose();
    _pswController.dispose();
    _phoneController.dispose();
    _verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "REGISTRATION",
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
              color: Color.fromRGBO(24, 29, 40, 1)
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, FadeRoute((Login())));
              },
              icon: Icon(Icons.bubble_chart),
            ),
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
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: "SF-UI-Display-Regular"),
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)],
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                                prefixIcon: IconButton(
                                    onPressed: _openCupertinoCountryPicker,
                                    padding: EdgeInsets.all(0.0),
                                    icon: iscounty == null
                                        ? getFlagImage()
                                        : iscounty
                                ),
                                labelText: "Phone",
                                hintText: "Enter You Phone Number",
                              ),
                              validator: (String value) {
                                formDE['phone'] = value;
                                return value
                                    .trim()
                                    .length > 0 ? null : '请输入账号';
                              },
                            ),
                          ),
                          // 验证码
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: "SF-UI-Display-Regular"),
                              controller: _verifyController,
                              keyboardType: TextInputType.number,
                              // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6)],
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                                labelText: "Verify Code",
                                hintText: "Enter You Verify Code",
                                suffixIcon: Container(
                                  child: FlatButton(
                                    onPressed: getCtcode,
                                    child: getc ? CupertinoActivityIndicator(
                                      radius: 10.0,
                                      animating: true,
                                    ) : Text(_txts),
                                  ),
                                ),
                              ),
                              validator: (String value) {
                                formDE['captcha'] = value;
                                return value
                                    .trim()
                                    .length > 0 ? null : '请输入验证码';
                              },
                            ),
                          ),
                          //用户名
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: "SF-UI-Display-Regular"),
                              controller: _nameController,
                              cursorColor: Colors.pinkAccent,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "UserName",
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
                                hintText: "Enter You Name",
                              ),
                              validator: (String value) {
                                formDE['nickname'] = value;
                                return value
                                    .trim()
                                    .length <= 0 ? '请输入合法的用户名' : null;
                              },
                            ),
                          ),
                          //密码
                          Container(
                            width: 325.0,
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: "SF-UI-Display-Regular"),
                              obscureText: !this.passWordVisible,
                              controller: _pswController,
                              cursorColor: Colors.pinkAccent,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "PassWord",
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
                          //注册
                          Hero(
                            tag: 'LOGIN',
                            child: Container(
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
                                            ? doRegis()
                                            : null,
                                        borderRadius: BorderRadius.circular(
                                            8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text("REGISTRATION",
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
                          )

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
      ),
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
  'captcha': null,
  'password': null,
  'nickname': null
};