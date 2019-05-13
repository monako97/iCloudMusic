import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart'; //Toast插件
import 'package:icloudmusic/Utils/HttpUtils.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
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
        FToash("验证码已发送", "验证码已发送", true, context);
      } else {
        _txts = '重新获取';
        setState(() => getc = false);
        FToash(result['message'], "获取验证码失败", false, context);
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
          FToash(result['message'], "注册成功", true, context);
        } else {
          setState(() => load = false);
          FToash(result['message'], "注册失败", false, context);
        }
      } else {
        setState(() => load = false);
        FToash(as['message'], "验证码错误", false, context);
      }
    } else {
      FToash("请先获取验证码", "请先获取验证码", false, context);
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
              fontFamily: F.Medium,
              color: C.DEF),
        ),
        centerTitle: true,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: C.DEF
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 15.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                                fontFamily: F.Regular),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11)],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              focusedBorder: C.InputBorderNone,
                              focusedErrorBorder: C.InputBorderNone,
                              enabledBorder: C.InputBorderNone,
                              errorBorder: C.InputBorderNone,
                              prefixIcon: IconButton(
                                  onPressed: _openCupertinoCountryPicker,
                                  padding: EdgeInsets.all(0.0),
                                  icon: iscounty == null
                                      ? FlagImage()
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
                                fontFamily: F.Regular),
                            controller: _verifyController,
                            keyboardType: TextInputType.number,
                            // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6)],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              focusedBorder: C.InputBorderNone,
                              focusedErrorBorder: C.InputBorderNone,
                              enabledBorder: C.InputBorderNone,
                              errorBorder: C.InputBorderNone,
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
                                fontFamily: F.Regular),
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
                              focusedBorder: C.InputBorderNone,
                              focusedErrorBorder: C.InputBorderNone,
                              enabledBorder: C.InputBorderNone,
                              errorBorder: C.InputBorderNone,
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
                                fontFamily: F.Regular),
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
                                gradient: LinearGradient(colors: C.BTN_DEF),
                                boxShadow: C.BTN_SHADOW),
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
                                                fontFamily: F.Regular)),
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

Map<String, dynamic> formDE = {
  'phone': null,
  'captcha': null,
  'password': null,
  'nickname': null
};