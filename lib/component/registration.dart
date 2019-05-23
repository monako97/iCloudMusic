import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
import 'package:icloudmusic/component/loading.dart';
import 'package:icloudmusic/utils/commotRequest.dart';
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}
class _RegistrationState extends State<Registration> {
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _verifyController;
  TextEditingController _pswController;
  bool _passWordVisible = false; //密码是否可见
  bool _load = false; //加载状态
  bool _getC = false;
  bool _isV = false;
  String _txt = '获取验证码';
  String _ctCode = '86';
  Widget _isCounty;
  // 获取验证
  getCertificationCode() async {
    if (formDE['phone'].trim().length > 6) {
      setState(() => _getC = true);
      // 收起键盘
      FocusScope.of(context).requestFocus(FocusNode());
      await H.getCertificationCode(_ctCode, formDE['phone']).then((e){
        print(e);
        if (e != null && e['code'] == 200) {
          _txt = '已发送';
          _isV = true;
          setState(() => _getC = false);
          fuToast("验证码已发送", "验证码已发送", true, context);
        } else {
          _txt = '重新获取';
          setState(() => _getC = false);
          fuToast(e['message'], "获取验证码失败", false, context);
        }
      });
    }
  }
  // 注册
  doRegistration() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    if (_isV) {
      setState(() => _load = true);
      await H.verifyCertificationCode(_ctCode, formDE['phone'], formDE['captcha']).then((e){
        if (e != null && e['code'] == 200) {
          //验证成功后开始注册
          print(e);
          H.doRegistration(formDE).then((e){
            print(e);
            if (e != null && e['code'] == 200) {
              setState(() => _load = false);
              fuToast(e['message'], "注册成功", true, context);
            } else {
              setState(() => _load = false);
              fuToast(e['message'], "Ծ‸ Ծ注册失败", false, context);
            }
          });
        } else {
          setState(() => _load = false);
          fuToast(e['message'], "Ծ‸ Ծ验证码错误", false, context);
        }
      });
    } else {
      fuToast(" Ծ‸ Ծ请先获取验证码", " Ծ‸ Ծ请先获取验证码", false, context);
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
  void _openCountryPicker() =>
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return CountryPickerCupertino(
              pickerItemHeight: 50.0,
              pickerSheetHeight: 300.0,
              onValuePicked: (country) =>
                  setState(() {
                    _isCounty = CountryPickerUtils.getDefaultFlagImage(country);
                    _ctCode = country.phoneCode;
                  }),
            );
          });

  @override
  void dispose() {
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
                              focusedBorder: C.inputBorderNone,
                              focusedErrorBorder: C.inputBorderNone,
                              enabledBorder: C.inputBorderNone,
                              errorBorder: C.inputBorderNone,
                              prefixIcon: IconButton(
                                  onPressed: _openCountryPicker,
                                  padding: EdgeInsets.all(0.0),
                                  icon: _isCounty == null
                                      ? flagImage()
                                      : _isCounty
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
                              focusedBorder: C.inputBorderNone,
                              focusedErrorBorder: C.inputBorderNone,
                              enabledBorder: C.inputBorderNone,
                              errorBorder: C.inputBorderNone,
                              labelText: "Verify Code",
                              hintText: "Enter You Verify Code",
                              suffixIcon: Container(
                                child: FlatButton(
                                  onPressed: getCertificationCode,
                                  child: _getC ? CupertinoActivityIndicator(
                                    radius: 10.0,
                                    animating: true,
                                  ) : Text(_txt),
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
                              focusedBorder: C.inputBorderNone,
                              focusedErrorBorder: C.inputBorderNone,
                              enabledBorder: C.inputBorderNone,
                              errorBorder: C.inputBorderNone,
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
                            obscureText: !this._passWordVisible,
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
                              focusedBorder: C.inputBorderNone,
                              focusedErrorBorder: C.inputBorderNone,
                              enabledBorder: C.inputBorderNone,
                              errorBorder: C.inputBorderNone,
                              hintText: "Enter You PassWord",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    this._passWordVisible =
                                    !this._passWordVisible;
                                  });
                                },
                                icon: Icon(_passWordVisible
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
                                boxShadow: C.btnShadow),
                            child: Builder(builder: (context) {
                              return Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () =>
                                      Form.of(context).validate()
                                          ? doRegistration()
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
            _load ? Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: loadingWidget(),
            ) : Container(),
          ],
        ),
      )
    );
  }
}

Map<String, dynamic> formDE = {
  'phone': null,
  'captcha': null,
  'password': null,
  'nickname': null
};