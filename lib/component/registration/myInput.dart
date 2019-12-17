import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/widget/loading.dart';
class VerifyCodeInput extends StatefulWidget{
  final setCaptcha;
  final setVerify;
  final getPhone;
  final getCountry;
  VerifyCodeInput({
    Key key,
    @required this.setCaptcha,
    @required this.setVerify,
    @required this.getPhone,
    @required this.getCountry
  }) : super(key : key);
  @override
  _VerifyCodeInput createState() => _VerifyCodeInput();
}
class _VerifyCodeInput extends State<VerifyCodeInput>{
  TextEditingController _verifyController;
  final InputBorder inputBorderNone = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  );

  @override
  void initState() {
    super.initState();
    _verifyController = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    _verifyController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
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
          focusedBorder: inputBorderNone,
          focusedErrorBorder: inputBorderNone,
          enabledBorder: inputBorderNone,
          errorBorder: inputBorderNone,
          labelText: "Verify Code",
          hintText: "Enter You Verify Code",
          suffixIcon: Container(
            child: MyLoadBtn(
              setVerify: widget.setVerify,
              getPhone: widget.getPhone,
              getCountry: widget.getCountry,
            ),
          ),
        ),
        validator: (String value) {
          widget.setCaptcha(value);
          return value.trim().length > 0 ? null : '请输入验证码';
        },
      ),
    );
  }
}
class MyLoadBtn extends StatefulWidget{
  final setVerify;
  final getPhone;
  final getCountry;
  MyLoadBtn({
    Key key,
    @required this.setVerify,
    @required this.getPhone,
    @required this.getCountry
  }) : super(key : key);
  @override
  _MyLoadBtn createState() => _MyLoadBtn();
}
class _MyLoadBtn extends State<MyLoadBtn>{
  String txt = '获取验证码';
  bool _getC = false;
  // 获取验证
  getCertificationCode() async {
    final String phone = widget.getPhone();
    if(phone!=null){
      if (phone.trim().length > 6) {
        _getC = true;
        setState(() => {});
        // 收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
        var data = await HttpUtils.request('/captch/sent',
            data: {'phone': phone,
              'ctcode': widget.getCountry()
            }, load: true);
        if (data != null && data['code'] == 200) {
          txt = '已发送';
          widget.setVerify(true);
          Loading.toast("验证码已发送", true);
        } else {
          txt = '重新获取';
        }
        _getC = false;
        setState(() => {});
      }
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: getCertificationCode,
      child: _getC ? CupertinoActivityIndicator(
        radius: 10.0,
        animating: true,
      ) : Text(txt),
    );
  }
}
class MyInput extends StatefulWidget{
  final setInputValue;
  final String labelText;
  final String hintText;
  final String validatorText;
  MyInput({
    Key key,
    @required this.setInputValue,
    @required this.validatorText,
    @required this.hintText,
    @required this.labelText
  }) : super(key : key);
  @override
  _MyInput createState() => _MyInput();
}
class _MyInput extends State<MyInput>{
  TextEditingController _textEditingController;
  final InputBorder inputBorderNone = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  );
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.0,
      margin: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(fontSize: 20.0,
            fontFamily: "SF-UI-Display-Regular"),
        controller: _textEditingController,
        cursorColor: Colors.pinkAccent,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.labelText,
          filled: true,
          contentPadding:
          EdgeInsets.only(left: 20.0,
              right: 0.0,
              top: 20.0,
              bottom: 20.0),
          focusedBorder: inputBorderNone,
          focusedErrorBorder: inputBorderNone,
          enabledBorder: inputBorderNone,
          errorBorder: inputBorderNone,
          hintText: widget.hintText,
        ),
        validator: (String value) {
          widget.setInputValue(value);
          return value.trim().length <= 0 ? widget.validatorText : null;
        },
      ),
    );
  }
}