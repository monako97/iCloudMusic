import 'package:icloudmusic/component/login/myHeroButton.dart';
import 'package:icloudmusic/component/login/passWordInput.dart';
import 'package:icloudmusic/component/registration/myInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/widget/loading.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/component/login/login.dart';
import 'package:icloudmusic/component/login/userInput.dart';
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}
class _RegistrationState extends State<Registration> {
  Map<String, dynamic> formDE;
  bool _isV = false;
  String _ctCode = '86';
  void setPhone(phone){
    formDE["phone"] = phone;
  }
  void setCountry(country){
    _ctCode = country;
  }
  void setCaptcha(captcha){
    formDE["captcha"] = captcha;
  }
  void setVerify(bool verify){
    _isV = verify;
  }
  void setPassWord(String password){
    formDE["password"] = password;
  }
  void setNickName(String nickname){
    formDE["nickname"] = nickname;
  }
  String getCountry() => _ctCode;
  String getPhone() => formDE["phone"];

  doRegistration() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    if (_isV) {
      final verifyState = await HttpUtils.request('/captch/verify', data: {
        'phone': formDE['phone'],
        'ctcode': _ctCode,
        'captcha': formDE['captcha']
      },load: true);
      if(verifyState != null && verifyState['code'] == 200){
        print(verifyState);
        final resp = await HttpUtils.request('/captch/register', data: formDE,load: true);
        if(resp != null && resp['code'] == 200){
          Loading.toast("注册成功", true);
        }
      }
    } else {
      Loading.toast(" Ծ‸ Ծ请先获取验证码", false);
    }
  }

  @override
  void initState() {
    super.initState();
    formDE = {
      'phone': null,
      'captcha': null,
      'password': null,
      'nickname': null
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Loading.context = context; // 注入context
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
              Navigator.of(context).pushReplacement(
                  FadeRoute(Login())
              );
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
                        LoginUserInput(
                          setCountry: setCountry,
                          setPhone: setPhone,
                        ),
                        // 验证码
                        VerifyCodeInput(
                          setCaptcha: setCaptcha,
                          setVerify: setVerify,
                          getPhone: getPhone,
                          getCountry: getCountry,
                        ),
                        //用户名
                        MyInput(
                          validatorText: '请输入合法的用户名',
                          labelText: "UserName",
                          hintText: "Enter You Name",
                          setInputValue: setNickName,
                        ),
                        // 密码
                        PassWordInput(
                          setPassWord: setPassWord,
                          marginTop: 20.0,
                        ),
                        MyHeroButton(
                          title: "REGISTRATION",
                          tag: 'LOGIN',
                          callBack: doRegistration,
                          marginBottom: 0.0
                        )
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }
}
